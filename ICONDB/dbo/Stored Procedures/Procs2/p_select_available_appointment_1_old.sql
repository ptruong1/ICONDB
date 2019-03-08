-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment_1_old]
	@facilityID	int,
	@locationID int,
	@InmateID	varchar(12),
	@scheduleDate	smalldatetime,
	@VisitorID	int	,
	@VisitType  tinyint
		
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
    --Declare @tempSchedule As typeVisitAvailSchedule  ;
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
    SET @ApmIncrement =0;
    -- Will get locationID base on ImateID
    select @timezone = timezone from leg_Icon.dbo.tblfacility with(nolock) where FacilityID =@facilityID ;
   
    SET @hour = DATEPART(HH,GETDATE()) + @timezone;
    SET @localTime = DATEADD(hh,@timezone,getdate());
    SET  @locationID = ISNULL( @locationID,0);
	SET @ApmIncrement =0;
	SET @MinTimeVisit =0;
	SET @Curenttime= CONVERT(time(0),@localTime);
	SET @InmateID = LTRIM(rtrim(@inmateID));
	SET @MaxTimevisit = 20;
	SET @VisitPerDay =0;
	SET @VisitPerWeek  =0;
	SET @VisitPerMonth =0;
	SET @LocLimitTime =0;
	SET @DayLimitTime=0;
	SET @MaxFTime = 0;
	SET @InterApm =0;
	Select @MinTimeVisit = Isnull(MinDuration,0) ,@ApmIncrement =isnull(Increment,0), @MaxFTime = MaxDuration ,@hourBeforeVisit = HourBeforeVisit,@InterApm = isnull(InterSection,0) ,@VisitPerDay = isnull(VisitPerDay,0), @VisitPerWeek=isnull(VisitPerWeek,0) ,@VisitPerMonth=isnull(VisitPerMonth,0)  from tblVisitFacilityConfig with(nolock) where FacilityID =@facilityID ;
	--Select @locationID = locationID from tblVisitInmateConfig where InmateID =@InmateID and FacilityID =@facilityID 
	--select @ApmIncrement, @InterApm;
	
	Select @RecordOpt = isnull(RecordOpt,'Y'),@RelationShipID=RelationShipID   from leg_Icon.dbo.tblVisitors with(nolock) where VisitorID= @VisitorID ;
	--if(@ApmIncrement =0) set @ApmIncrement =1;
	if ( @RelationShipID in( 0,7,8))
		SET @hourBeforeVisit =1;
	
	if(CHARINDEX('|', @InmateID) >0)
		SET @InmateID = SUBSTRING(@InmateID,1,CHARINDEX('|', @InmateID)-1);
	--if(@locationID =0) 
	Select @locationID = locationID,@InmateLimitTime  =ISNULL(MaxVisitTime,@MaxFTime), @VisitPerDay = isnull(VisitPerDay,@VisitPerDay), @VisitPerWeek=isnull(VisitPerWeek,@VisitPerWeek) ,@VisitPerMonth=isnull(VisitPerMonth,@VisitPerMonth) ,@ExtID = ExtID
			FROM tblVisitInmateConfig with(nolock) where InmateID =@InmateID  and FacilityID =@facilityID ;
	
	if(@InmateLimitTime = 0) set @InmateLimitTime = @MaxFTime;
	--Select @locationID;

	if (@VisitPerDay is not NULL and @VisitPerDay >0)
	 begin
		if (select COUNT(*) from tblVisitEnduserSchedule with(nolock) where FacilityID = @facilityID and InmateID = @InmateID and ApmDate = @scheduleDate and status in (2,3,5,8) ) > = @VisitPerDay
		 begin
			--exec p_select_out_schedule 	@period,@InterApm  ,@ApmIncrement,	@RecordOpt ,@hourbeforevisit ,	@NumOfStations  ,	@InmateID ,	@visitorID ,@scheduleDate ,	@localTime ,@tempSchedule 
			--	return 0;
			goto SelectOUT;
		 end
	 end 	
	if (@VisitPerWeek is not NULL and @VisitPerWeek >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(wk,ApmDate) =DATEPART(wk,@scheduleDate) and InmateID =@InmateID and status in(2,3,5,8)) >= @visitPerWeek 
		 begin
			--exec p_select_out_schedule
			--			@period,
			--			@InterApm  ,
			--			@ApmIncrement,
			--			@RecordOpt ,
			--			@hourbeforevisit ,
			--			@NumOfStations  ,
			--			@InmateID ,
			--			@visitorID ,
			--			@scheduleDate ,
			--			@localTime ,
			--			@tempSchedule 
			--	return 0;
			goto SelectOUT;
		 end
	 end 	
	If(@VisitPerMonth  is not NULL and @VisitPerMonth >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(MONTH,ApmDate) =DATEPART(MONTH,@scheduleDate) and InmateID =@InmateID and status in(2,3,5,8)) >= @VisitPerMonth 
		--	exec p_select_out_schedule
		--				@period,
		--				@InterApm  ,
		--				@ApmIncrement,
		--				@RecordOpt ,
		--				@hourbeforevisit ,
		--				@NumOfStations  ,
		--				@InmateID ,
		--				@visitorID ,
		--				@scheduleDate ,
		--				@localTime ,
		--				@tempSchedule 
		--		return 0;
			goto SelectOUT;
	 end
	if(select COUNT(*) from tblVisitCellSchedule with(nolock) where FacilityID =@facilityID  ) >0
	 begin
	 
		SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,@InterApm)  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,
		 @FromTime3= fromTime3, @toTime3 = totime3, @LocLimitTime= LimitTime  from [leg_Icon].[dbo].[tblVisitCellSchedule]  with(nolock)
		    where FacilityID = @facilityID and ExtID =@ExtID and scheduleday= @dw and visitType =@VisitType;
	 
	 
	 end	 
	Else
	 begin 
		if(select COUNT(*) from tblVisitLocationSchedule with(nolock) where FacilityID =@facilityID and LocationID =@locationID) >0
		 begin
			--select 'TEST'
			SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,@InterApm )  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,
			 @FromTime3= fromTime3, @toTime3 = totime3, @LocLimitTime= LimitTime  from [leg_Icon].[dbo].[tblVisitLocationSchedule] with(nolock)
				where FacilityID = @facilityID and LocationID =@locationID and scheduleday= @dw and visitType =@VisitType;
		 end 
		else
		 begin
			SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,@InterApm)  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,@DayLimitTime= LimitTime,  @FromTime3= fromTime3, @toTime3 = totime3 
				from [leg_Icon].[dbo].[tblVisitFacilitySchedule] with(nolock)
			   where FacilityID = @facilityID and scheduleday= @dw and FvisitType =@VisitType;
	     end
	end
    --select @FromTime2, @toTime2 ,'TESt'
	if(@locationID >0 and @VisitType =2)	
	 begin
		SELECT @NumOfStations=  count(*)  FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID and LocationID =@locationID  And (status=1 or status is null) and stationType=@VisitType ;
		--SELECT @LocationName=  LocationName FROM [leg_Icon].[dbo].tblVisitLocation where LocationID = @locationID
	 end
	else
	 begin
		SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID  And (status=1 or status is null) and stationType=@VisitType;
		--SET @LocationName='Visit Area'
	 end
	--select @NumOfStations;
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
	
	if(@MaxTimevisit >0)
		set @period =@MaxTimevisit;   
	if(@period =0 or @period is null)
		SET @period =15;
	-- remember limittime = limittime + interAmpt time
	if(@period <=60)
		SET @AppointPerStation = 60/(@period ) ;
	else 
		SET @AppointPerStation = (CAST(left(@toTime1,2) as int) - CAST(left(@fromTime1,2) as int))/(@period ) ;
	SET @appointPerPeriod = @AppointPerStation* @NumOfStations;
	--If (@MinTimeVisit =0 or  @MinTimeVisit is null) 
	--	SET @MinTimeVisit = @period;
	
	--Create table #tempSchedule(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), CurrentApm smallint)
	
	--SET @ScheduleTime = dateadd(hour,@hourbeforeVisit, convert(time(0),@FromTime1))
	
	--Period 1
	if(@VisitType =1)
	 Begin
		if(@FromTime1 is not null)
		 begin
			SET @ScheduleTime = convert(time(0),@FromTime1);	
			While @ScheduleTime  <convert(time(0),@toTime1)
			 begin
				
				select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
						where FacilityID = @facilityID and
							  ApmDate  = @scheduleDate and 
							 -- LocationID = @locationID and
							 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
							  [status] <= 3  and (visitType = 1 ) ;
							  
				select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
						where FacilityID = @facilityID and
							  ApmDate  = @scheduleDate and 
							-- LocationID = @locationID and					  
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
							  --LocationID = @locationID and
							  [status] <= 3 and (visitType = 1 ) ;
							  
				select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
						where FacilityID = @facilityID and
							  ApmDate  = @scheduleDate and 
							  --LocationID = @locationID and
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
							  --LocationID = @locationID and
							  [status] <= 3 and (visitType = 1 ) ;
							  
				select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
						where FacilityID = @facilityID and
							  ApmDate  = @scheduleDate and 
							  --LocationID = @locationID and
							  ApmTime  = @ScheduleTime ;
							  --group by facilityID,ApmDate,ApmDate
				--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
				SET @currentApm =@currentApm + @currentApmTemp;
				Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@currentApm);
				SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
				SET  @ScheduleTime= convert(time(0),@ScheduleTime);
			 End 
		 end
	 end
	else
	 Begin
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
							  [status] <= 3  and (visitType = 2 ) ;
							  
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
							  [status] <= 3 and (visitType = 2) ;
							  
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
							  [status] <= 3 and (visitType =2) ;
							  
				select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
						where FacilityID = @facilityID and
							  ApmDate  = @scheduleDate and 
							  --LocationID = @locationID and
							  ApmTime  = @ScheduleTime ;
							  --group by facilityID,ApmDate,ApmDate
				--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
				SET @currentApm =@currentApm + @currentApmTemp;
				Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@currentApm);
				SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
				SET  @ScheduleTime= convert(time(0),@ScheduleTime);
			 End 
		 end
	 end
	SelectOUT:
	--select @ApmIncrement, @InterApm;
	--SET @InterApm =0;
	--SET @ApmIncrement =0; @MinTimeVisit    as ApmTimeMin,  @MaxTimevisit -@InterApm  + (@ApmIncrement *2) 
	--select * from @tempSchedule;
	--if(@InterApm = 0 or @ApmIncrement =0) // old  @period -@InterApm     as ApmTimeMin,  @period -@InterApm +@ApmIncrement * 2  
	--	SET @MinTimeVisit = @MaxTimevisit; @MinTimeVisit
	select  ScheduleTime,  @period -@InterApm     as ApmTimeMin,  @period -@InterApm +(@ApmIncrement * 2)   as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
	from @tempSchedule where CurrentApm < @NumOfStations and DATEADD(hh,DATEPART(hh,ScheduleTime), ScheduleDate) > DATEADD(Hour,@hourbeforevisit, @localTime) 
	and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	--exec p_select_out_schedule 
	--					@period,
	--					@InterApm  ,
	--					@ApmIncrement,
	--					@RecordOpt ,
	--					@hourbeforevisit ,
	--					@NumOfStations  ,
	--					@InmateID ,
	--					@visitorID ,
	--					@scheduleDate ,
	--					@localTime ,
	--					@tempSchedule 
END

