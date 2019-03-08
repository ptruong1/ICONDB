-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment_140604_TEST]
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
	Declare @period smallint, @hour tinyint, @minute tinyint, @year smallint, @AppPerPeriod smallint,@month tinyint,@InterApm int,@flatform tinyint, @LocationName varchar(30),@MaxTimevisit smallint, @MaxFTime smallint, @MaxInmateTime smallint;
	Declare	@FromTime1 varchar(5), @toTime1 varchar(5),@FromTime2 varchar(5), @toTime2 varchar(5), @FromTime3 varchar(5), @toTime3 varchar(5),@day tinyint, @dw tinyint, @NumOfStations smallint,@timezone smallint,@currentApmTemp smallint,@RecordOpt char(1),@Curenttime time(0),
			@AppointPerStation tinyint, @appointPerPeriod smallint ,@ScheduleTime time(0), @currentApm smallint,@localTime datetime, @ApmIncrement tinyint, @hourBeforeVisit smallint, @ExtID varchar(15);
    Declare @VisitPerDay tinyint,  @VisitPerWeek tinyint,  @VisitPerMonth tinyint,@InmateLimitTime tinyint;
    -- Insert statements for procedure here
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
    SET @ApmIncrement =5;
    SET @InterApm  =0;
    SET @MaxInmateTime =0;
    SET @MaxFTime =0;
    SET @VisitPerMonth =0;
    -- Will get locationID base on ImateID
    select @timezone = timezone,@flatform = flatform  from leg_Icon.dbo.tblfacility where FacilityID =@facilityID ;
    Select @hourBeforeVisit = isnull(HourBeforeVisitOnSite,0),@ApmIncrement= isnull(Increment,0),@MaxFTime=isnull(MaxDuration,0),@InterApm = isnull(InterSection,0),@VisitPerDay = isnull(VisitPerDay,0), @VisitPerWeek=isnull(VisitPerWeek,0) ,@VisitPerMonth=isnull(VisitPerMonth,0)    from tblVisitfacilityConfig where FacilityID =@facilityID ;
    SET @hour = DATEPART(HH,GETDATE()) + @timezone;
    SET @localTime = DATEADD(hh,@timezone,getdate());
    SET  @locationID = ISNULL( @locationID,0);
	
	SET @Curenttime= CONVERT(time(0),@localTime);
	SET @InmateID = LTRIM(rtrim(@inmateID));
	
	--select @ApmIncrement,@InterApm,@MaxTimevisit ;
	--Select @locationID = locationID from tblVisitInmateConfig where InmateID =@InmateID and FacilityID =@facilityID 
	if(CHARINDEX('|', @InmateID) >0)
		SET @InmateID = SUBSTRING(@InmateID,1,CHARINDEX('|', @InmateID)-1);
	--if(@locationID =0) 
	--	Select @locationID = locationID,@MaxInmateTime =ISNULL( MaxVisitTime,@MaxTimevisit),@ExtID = ExtID  from tblVisitInmateConfig where InmateID =@InmateID  and FacilityID =@facilityID ;
		Select @locationID = locationID,@InmateLimitTime  =ISNULL(MaxVisitTime,@MaxFTime), @VisitPerDay = isnull(VisitPerDay,@VisitPerDay), @VisitPerWeek=isnull(VisitPerWeek,@VisitPerWeek) ,@VisitPerMonth=isnull(VisitPerMonth,@VisitPerMonth) ,@ExtID = ExtID
			FROM tblVisitInmateConfig with(nolock) where InmateID =@InmateID  and FacilityID =@facilityID ;
	--Select  @locationID;
	
	if (@VisitPerDay is not NULL and @VisitPerDay >0)
	 begin
		if (select COUNT(*) from tblVisitEnduserSchedule where FacilityID = @facilityID and InmateID = @InmateID and ApmDate = @scheduleDate and status in (2,3,5,8) ) > = @VisitPerDay
		 begin			
			return 0;
		 end
	 end 	
	if (@VisitPerWeek is not NULL and @VisitPerWeek >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(wk,ApmDate) =DATEPART(wk,@scheduleDate) and InmateID =@InmateID and status in(2,3,5,8)) >= @visitPerWeek 
		 begin			
			return 0;
		 end
	 end 	
	If(@VisitPerMonth  is not NULL and @VisitPerMonth >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(MONTH,ApmDate) =DATEPART(MONTH,@scheduleDate) and InmateID =@InmateID and status in(2,3,5,8)) >= @VisitPerMonth 
		
			return 0;
	 end
	
	
   ---------- Add Cell Schedule and Location Schedule
    --select @MaxTimevisit;
	if(select COUNT(*) from tblVisitCellSchedule with(nolock) where FacilityID =@facilityID ) >0
	 begin
	 
		SELECT @period = isnull(LimitTime,@MaxTimevisit), @InterApm= isnull(InterApm,0)  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,
		 @FromTime3= fromTime3, @toTime3 = totime3  from [leg_Icon].[dbo].[tblVisitCellSchedule]  with(nolock)
		    where FacilityID = @facilityID and ExtID =@ExtID and scheduleday= @dw and visitType =1;
	 
	 
	 end	 
	Else
	 begin 
		if(select COUNT(*) from tblVisitLocationSchedule with(nolock) where FacilityID =@facilityID and LocationID =@locationID) >0
		 begin
			--select 'TEST'
			SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,1)  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,
			 @FromTime3= fromTime3, @toTime3 = totime3   from [leg_Icon].[dbo].[tblVisitLocationSchedule] with(nolock)
				where FacilityID = @facilityID and LocationID =@locationID and scheduleday= @dw and visitType =1;
		 end 
		else
		 begin
			SELECT @period = isnull(LimitTime,15), @InterApm= InterApm  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2, @FromTime3= fromTime3, @toTime3 = totime3 
				from [leg_Icon].[dbo].[tblVisitFacilitySchedule] with(nolock)
			   where FacilityID = @facilityID and scheduleday= @dw and FvisitType =1;
	     end
	end
	--------------------End new edit--------------------
    --select @period;
	if(@locationID >0)	
	 begin
		SELECT @NumOfStations=  count(*)  FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID and LocationID =@locationID;
		--SELECT @LocationName=  LocationName FROM [leg_Icon].[dbo].tblVisitLocation where LocationID = @locationID
	 end
	else
	 begin
		SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID 
		--SET @LocationName='Visit Area'
	 end
	
	
	-- Make change for Maxduation for some inmate
	if(@MaxFTime >0) set @MaxTimevisit = @MaxFTime;
	If( @MaxInmateTime >0) set @MaxTimevisit= @MaxInmateTime;
	if(@MaxTimevisit >0) set @period =@MaxTimevisit;  
	if(@period =0) SET @period =15; 
	--select @MaxFTime, @MaxTimevisit,@period; 
	-- remember limittime = limittime + interAmpt time
	if(@period <=60)
		SET @AppointPerStation = 60/(@period ) ;
	else 
		SET @AppointPerStation = (CAST(left(@toTime1,2) as int) - CAST(left(@fromTime1,2) as int))/(@period ) ;
	SET @appointPerPeriod = @AppointPerStation* @NumOfStations;
	--Create table #tempSchedule(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), CurrentApm smallint)
	Declare @tempSchedule table(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), CurrentApm smallint) ;
	--SET @ScheduleTime = dateadd(hour,@hourbeforeVisit, convert(time(0),@FromTime1))
	if(@hourBeforeVisit =0)
		set @period = @period + @InterApm; 
	
	SET @ScheduleTime = convert(time(0),@FromTime1);
	--Period 1
	--select @MaxTimevisit;
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
		--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
		SET @currentApm =@currentApm + @currentApmTemp;
		
		Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@currentApm);
		SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
	 End
	 -- Period 2
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
	 
	 ---- Period 3
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
	-- select * from @tempSchedule
	--select * ,@NumOfStations MaxApmPerPeriod,(@NumOfStations- CurrentApm) as ApmAvailable, @period as ApmTimeLimit, 'Y' RecordOpt  from #tempSchedule where CurrentApm < @appointPerPeriod
	-- Will Implement Visitor and Inmate record later
	SelectOUT:
	
	select @ApmIncrement = Increment from leg_Icon.dbo.tblVisitRate where RateID =@facilityID ;
	select @RecordOpt = isnull(RecordOpt,'Y') from leg_Icon.dbo.tblVisitors where VisitorID= @VisitorID ;
	--
	select *,DATEADD(MI,DATEPART(HH,ScheduleTime)* 60 + DATEPART(MINUTE ,ScheduleTime), ScheduleDate)   ,DATEADD(HOUR,@hourBeforeVisit , @localTime) , @localTime  from  @tempSchedule ;
	select  ScheduleTime,@period -@InterApm as ApmTimeMin,  @period -@InterApm   as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
	from @tempSchedule where CurrentApm < @NumOfStations and DATEADD(MI,DATEPART(HOUR ,ScheduleTime) *60 +   DATEPART(MI ,ScheduleTime), ScheduleDate) >= DATEADD(MINUTE,@hourBeforeVisit , @localTime) 
	and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
END

