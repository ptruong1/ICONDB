-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment]
	@facilityID	int,
	@locationID int,
	@InmateID	varchar(12),
	@scheduleDate	smalldatetime,
	@VisitorID	int	
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @period smallint, @hour tinyint, @minute tinyint, @year smallint, @AppPerPeriod smallint,@month tinyint,@InterApm int,@flatform tinyint, @LocationName varchar(30);
	Declare @MaxTimevisit smallint, @LocLimitTime smallint, @InmateLimitTime smallint,@DayLimitTime smallint, @RelationShipID tinyint, @ExtID varchar(15);
	Declare	@FromTime1 varchar(5), @toTime1 varchar(5),@FromTime2 varchar(5), @toTime2 varchar(5), @FromTime3 varchar(5), @toTime3 varchar(5), @MaxFTime smallint, @MaxInmteTime smallint;
	Declare @day tinyint, @dw tinyint, @NumOfStations smallint,@timezone smallint,@currentApmTemp smallint,@RecordOpt char(1),@Curenttime time(0);
	Declare	@AppointPerStation tinyint, @appointPerPeriod smallint ,@ScheduleTime time(0), @currentApm smallint,@localTime datetime, @ApmIncrement tinyint, @hourBeforeVisit smallint, @MinTimeVisit tinyint, @VisitPerDay tinyint,@VisitPerWeek tinyint, @VisitPerMonth tinyint ;
    Declare @tempSchedule table(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), CurrentApm smallint) ;
    
    SET @year = DATEPART(YY,@scheduleDate );
    SET @month = DATEPART(M,@scheduleDate );
    SET @day = DATEPART(D,@scheduleDate );
    SET @dw = DATEPART(DW,@scheduleDate );
    SET @RecordOpt ='Y';
    SET @currentApm =0;
    SET @currentApmTemp =0;
    SET @period=15;
    SET @NumOfStations =0;
    SET  @hourBeforeVisit=1;
    SET @MaxTimevisit =0;
    SET @ApmIncrement =1;
    -- Will get locationID base on ImateID
    select @timezone = timezone from leg_Icon.dbo.tblfacility where FacilityID =@facilityID ;
   
    SET @hour = DATEPART(HH,GETDATE()) + @timezone;
    SET @localTime = DATEADD(hh,@timezone,getdate());
    SET  @locationID = ISNULL( @locationID,0);
	SET @ApmIncrement =5;
	SET @MinTimeVisit =0;
	SET @Curenttime= CONVERT(time(0),@localTime);
	SET @InmateID = LTRIM(rtrim(@inmateID));
	SET @MaxTimevisit = 20;
	SET @VisitPerDay =0;
	SET @LocLimitTime =0;
	SET @DayLimitTime=0;
	SET @MaxFTime = 0;
	SET @InterApm =0;
	Select @MinTimeVisit = Isnull(MinDuration,0) ,@ApmIncrement =isnull(Increment,1), @MaxFTime = MaxDuration ,@hourBeforeVisit = HourBeforeVisit,@InterApm = isnull(InterSection,0)   from tblVisitFacilityConfig where FacilityID =@facilityID 
	--Select @locationID = locationID from tblVisitInmateConfig where InmateID =@InmateID and FacilityID =@facilityID 
	Select @RecordOpt = isnull(RecordOpt,'Y'),@RelationShipID=RelationShipID   from leg_Icon.dbo.tblVisitors where VisitorID= @VisitorID ;
	if(@ApmIncrement =0) set @ApmIncrement =1;
	if ( @RelationShipID in( 0,7,8))
		SET @hourBeforeVisit =1;
	
	if(CHARINDEX('|', @InmateID) >0)
		SET @InmateID = SUBSTRING(@InmateID,1,CHARINDEX('|', @InmateID)-1);
	--if(@locationID =0) 
	Select @locationID = locationID,@InmateLimitTime  =ISNULL(MaxVisitTime,@MaxFTime), @VisitPerDay = isnull(VisitPerDay,0), @VisitPerWeek=isnull(VisitPerWeek,0) ,@VisitPerMonth=isnull(VisitPerMonth,0) ,@ExtID = ExtID
			FROM tblVisitInmateConfig with(nolock) where InmateID =@InmateID  and FacilityID =@facilityID ;
	
	--Select @locationID;

	if (@VisitPerDay is not NULL and @VisitPerDay >0)
	 begin
		if (select COUNT(*) from tblVisitEnduserSchedule where FacilityID = @facilityID and InmateID = @InmateID and ApmDate = @scheduleDate and status in (2,3,5,8) ) > = @VisitPerDay
		 begin
			goto SelectOUT;
		 end
	 end 	
	if (@VisitPerWeek is not NULL and @VisitPerWeek >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(wk,ApmDate) =DATEPART(wk,getdate()) and InmateID =@InmateID and status in(2,3,5,8)) > @visitPerWeek 
		 begin
			goto SelectOUT;
		 end
	 end 	
	If(@VisitPerMonth  is not NULL and @VisitPerMonth >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(MONTH,ApmDate) =DATEPART(MONTH,getdate()) and InmateID =@InmateID and status in(2,3,5,8)) > @VisitPerMonth 
			goto SelectOUT;
	 end
	if(select COUNT(*) from tblVisitCellSchedule with(nolock) where FacilityID =@facilityID  ) >0
	 begin
	 
		SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,@InterApm)  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,
		 @FromTime3= fromTime3, @toTime3 = totime3, @LocLimitTime= LimitTime  from [leg_Icon].[dbo].[tblVisitCellSchedule]  with(nolock)
		    where FacilityID = @facilityID and ExtID =@ExtID and scheduleday= @dw and visitType =2;
	 
	 
	 end	 
	Else
	 begin 
		if(select COUNT(*) from tblVisitLocationSchedule with(nolock) where FacilityID =@facilityID and LocationID =@locationID) >0
		 begin
			--select 'TEST'
			SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,@InterApm )  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,
			 @FromTime3= fromTime3, @toTime3 = totime3, @LocLimitTime= LimitTime  from [leg_Icon].[dbo].[tblVisitLocationSchedule] with(nolock)
				where FacilityID = @facilityID and LocationID =@locationID and scheduleday= @dw and visitType =2;
		 end 
		else
		 begin
			SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,@InterApm)  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,@DayLimitTime= LimitTime,  @FromTime3= fromTime3, @toTime3 = totime3 
				from [leg_Icon].[dbo].[tblVisitFacilitySchedule] with(nolock)
			   where FacilityID = @facilityID and scheduleday= @dw and FvisitType =2;
	     end
	end
    --select @FromTime2, @toTime2 ,'TESt'
	if(@locationID >0)	
	 begin
		SELECT @NumOfStations=  count(*)  FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID and LocationID =@locationID  And (status=1 or status is null);
		--SELECT @LocationName=  LocationName FROM [leg_Icon].[dbo].tblVisitLocation where LocationID = @locationID
	 end
	else
	 begin
		SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID  And (status=1 or status is null);
		--SET @LocationName='Visit Area'
	 end
	
	-- Make change for Maxduation for some inmate
	if(@InmateLimitTime >0)
		SET @MaxTimevisit = @InmateLimitTime;
	else
	 begin
		if (@LocLimitTime >0)
			SET @MaxTimevisit = @LocLimitTime;
		else
			if (@DayLimitTime >0)
				SET @MaxTimevisit = @DayLimitTime ;
	 end
	
	set @period =@MaxTimevisit;   
	-- remember limittime = limittime + interAmpt time
	if(@period <=60)
		SET @AppointPerStation = 60/(@period ) ;
	else 
		SET @AppointPerStation = (CAST(left(@toTime1,2) as int) - CAST(left(@fromTime1,2) as int))/(@period ) ;
	SET @appointPerPeriod = @AppointPerStation* @NumOfStations;
	If (@MinTimeVisit =0 or  @MinTimeVisit is null) 
		SET @MinTimeVisit = @period;
	
	--Create table #tempSchedule(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), CurrentApm smallint)
	
	--SET @ScheduleTime = dateadd(hour,@hourbeforeVisit, convert(time(0),@FromTime1))
	
	--Period 1
	if(@FromTime1 is not null)
	 begin
		SET @ScheduleTime = convert(time(0),@FromTime1);	
		While @ScheduleTime  <convert(time(0),@toTime1)
		 begin
			
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  LocationID = @locationID and
						 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
						  [status] <= 3 ;
						  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  LocationID = @locationID and					  
						  ApmTime  = @ScheduleTime ;
						  --group by facilityID,ApmDate,ApmDate
			
			SET @currentApm =@currentApm + @currentApmTemp;
			
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@currentApm);
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
			SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		 End
	 end
	 -- Period 2
	if(@FromTime2 is not null)
	  begin
		 SET @ScheduleTime = convert(time(0),@FromTime2);
		 While @ScheduleTime  < convert(time(0),@toTime2)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and
						  --ApmTime  between @ScheduleTime and DATEADD(MINUTE,LimitTime,@ScheduleTime) and
						  LocationID = @locationID and
						  [status] <= 3 ;
						  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  LocationID = @locationID and
						  ApmTime  = @ScheduleTime ;
						  --group by facilityID,ApmDate,ApmDate
			--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
			SET @currentApm =@currentApm + @currentApmTemp;
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@currentApm);
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
			SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		 End 
	  end
	 ---- Period 3
	 if(@FromTime3 is not null)
	  begin
		 SET @ScheduleTime = convert(time(0),@FromTime3);
		 While @ScheduleTime  < convert(time(0),@toTime3)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and
						  --ApmTime  between @ScheduleTime and DATEADD(MINUTE,LimitTime,@ScheduleTime) and
						  LocationID = @locationID and
						  [status] <= 3 ;
						  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  LocationID = @locationID and
						  ApmTime  = @ScheduleTime ;
						  --group by facilityID,ApmDate,ApmDate
			--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
			SET @currentApm =@currentApm + @currentApmTemp;
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@currentApm);
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
			SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		 End 
	 end
	SelectOUT:
	--select  ScheduleTime,@MinTimeVisit  as ApmTimeMin, @MaxTimevisit   as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
	--from @tempSchedule where CurrentApm < @NumOfStations and DATEADD(hh,DATEPART(hh,ScheduleTime), ScheduleDate) > DATEADD(Hour,@hourbeforevisit, @localTime) 
	--and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	select  ScheduleTime,@period -@InterApm as ApmTimeMin,  @period -@InterApm +@ApmIncrement * 2  as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
	from @tempSchedule where CurrentApm < @NumOfStations and DATEADD(hh,DATEPART(hh,ScheduleTime), ScheduleDate) > DATEADD(Hour,@hourbeforevisit, @localTime) 
	and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
END

