-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment_by_admin_old]
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
	Declare @period smallint, @hour tinyint, @minute tinyint, @year smallint, @AppPerPeriod smallint,@month tinyint,@InterApm int, @currentHour time(0),@MaxTimevisit smallint,@FromTime3 varchar(5), @toTime3 varchar(5);
	Declare	@FromTime1 varchar(5), @toTime1 varchar(5),@FromTime2 varchar(5), @toTime2 varchar(5),@day tinyint, @dw tinyint, @NumOfStations smallint,@timezone smallint,@currentApmTemp smallint,@CurrentDate date,
			@AppointPerStation tinyint, @appointPerPeriod smallint ,@ScheduleTime time(0), @currentApm smallint,@localTime datetime,@flatform tinyint, @recortOpt varchar(1), @Maxtime smallint, @RelationshipID smallint ;
	Declare @VisitPerday tinyint, @visitPerWeek tinyint, @VisitPerMonth tinyint,  @hourBeforeVisit tinyint,@ExtID varchar(15);		
    -- Insert statements for procedure here
    SET @year = DATEPART(YY,@scheduleDate );
    SET @month = DATEPART(M,@scheduleDate );
    SET @day = DATEPART(D,@scheduleDate );
    SET @dw = DATEPART(DW,@scheduleDate );
    SET @MaxTimevisit =0;
    SET @currentApm =0;
    SET @currentApmTemp =0;
    SET @period=15;
    SET @recortOpt='Y';
    -- Will get locationID base on ImateID
    select @timezone = timezone,@flatform = flatform  from leg_Icon.dbo.tblfacility where FacilityID =@facilityID ;
    SET @hour = DATEPART(HH,GETDATE()) + @timezone;
    SET @localTime = DATEADD(hh,@timezone,getdate());
    Select @VisitPerday= VisitPerDay,@visitPerWeek= VisitPerWeek, @VisitPerMonth=VisitPerMonth, @hourBeforeVisit=  HourBeforeVisitOnSite  from tblVisitFacilityConfig where FacilityID = @facilityID ;
    
   
    
    Select @locationID = locationID,@MaxTimevisit =ISNULL( MaxVisitTime,0),@VisitPerday= isnull(VisitPerDay,@VisitPerday) ,@visitPerWeek= isnull(VisitPerWeek,@visitPerWeek),
			 @VisitPerMonth=Isnull(VisitPerMonth,VisitPerMonth), @ExtID = ExtID  from tblVisitInmateConfig where InmateID =@InmateID  and FacilityID =@facilityID ;
	-- select @VisitPerday, 	@visitPerWeek, 	 @VisitPerMonth;
	SET  @locationID = ISNULL( @locationID,0);
    SET @currentHour = CONVERT(time(0),@localTime);
    SET @CurrentDate = CONVERT(date,@localTime);
    Select @recortOpt = isnull(recordopt,'Y') ,@RelationshipID = RelationshipID  from tblVisitors where  VisitorID = @VisitorID ;
	if(select COUNT(tblInmate.inmateID) from leg_Icon.dbo.tblInmate left join tblVisitInmateConfig on tblInmate.FacilityId = tblVisitInmateConfig.FacilityID and tblInmate.InmateID = tblVisitInmateConfig.InmateID
		where tblInmate.FacilityId = @facilityID and tblInmate.InmateID =@InmateID and SusStartDate <=@scheduleDate and SusEndDate>= @scheduleDate) > 0
		return 0;  
	If(@VisitPerday is not NULL and @VisitPerday > 0)
	 begin
		 
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  ApmDate =@scheduleDate and InmateID =@InmateID and status in(2,3,5,8)) > @VisitPerday
			Return 0;
		
	 end
		
	If(@visitPerWeek  is not NULL and @visitPerWeek  >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(wk,ApmDate) =DATEPART(wk,getdate()) and InmateID =@InmateID and status in(2,3,5,8)) > @visitPerWeek 
		 begin			
			Return 0;
		 end
			
	 end
	If(@VisitPerMonth  is not NULL and @VisitPerMonth >0)
	 begin
		IF(select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(MONTH,ApmDate) =DATEPART(MONTH,getdate()) and InmateID =@InmateID and status in(2,3,5,8)) > @VisitPerMonth 
			Return 0;
	 end
	 
	/* 
	
    SELECT @period = isnull(LimitTime,15), @InterApm= InterApm  , @FromTime1= fromTime1, @toTime1 = totime1,@FromTime2= fromTime2, @toTime2 = totime2,@FromTime3 = FromTime3,@toTime3=ToTime3    from [leg_Icon].[dbo].[tblVisitFacilitySchedule]
		where FacilityID = @facilityID and ScheduleDay =@dw and FvisitType =1;
	*/
	---------- Add Cell Schedule and Location Schedule
	if(select COUNT(*) from tblVisitCellSchedule with(nolock) where FacilityID =@facilityID ) >0
	 begin
	 
		SELECT @period = isnull(LimitTime,15), @InterApm= isnull(InterApm,1)  , @FromTime1= fromTime1, @toTime1 = totime1, @FromTime2= FromTime2,@toTime2=toTime2,
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
	
	--if(@locationID >0)	
	-- begin
		--SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID and LocationID =@locationID
	 --end
	--else
	-- begin
		SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID;
	 --end
	 --select @period
	if(@period =0) SET @period =15
	if(@MaxTimevisit >0) SET @period =@MaxTimevisit
	-- remember limittime = limittime + interAmpt time
	if(@period <=60)
		SET @AppointPerStation = 60/(@period );
	else 
		SET @AppointPerStation = (CAST(left(@toTime1,2) as int) - CAST(left(@fromTime1,2) as int))/(@period );
	SET @appointPerPeriod = @AppointPerStation* @NumOfStations;
	--select @FromTime1 ,@toTime1,@FromTime2,@toTime2
	Create table #tempSchedule(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), ApmTimeLimit smallint, CurrentApm smallint);
	--select @currentHour 
	if(@RelationshipID in (0,6,7) and @MaxTimevisit=0)
		SET @period = @period * 2;
	
	if(select COUNT(*) from [tblVisitEnduserSchedule]  where  (ApmTime  between @currentHour and DATEADD(MINUTE ,@period , @currentHour) or ApmTime  between  DATEADD(MINUTE ,-@period , @currentHour) and @currentHour)  and ApmDate=@scheduleDate) <@NumOfStations

	 begin
		if (@CurrentDate =@scheduleDate)
		 begin
			SET @Maxtime =0;
			if(@FromTime1 is not null)
			 begin
				if(@currentHour  >convert(time(0),@fromTime1) and @currentHour < convert(time(0),@toTime1) )
					SET @Maxtime  = DATEDIFF(MINUTE , @currentHour,convert(time(0),@toTime1));
			 end
			if(@FromTime2 is not null)
			 begin
				if(@currentHour  >convert(time(0),@fromTime2) and @currentHour < convert(time(0),@toTime2) )
					SET @Maxtime  = DATEDIFF(MINUTE , @currentHour,convert(time(0),@toTime2));
			 end
			if(@FromTime3 is not null)
			 begin
				if(@currentHour  >convert(time(0),@fromTime3) and @currentHour < convert(time(0),@toTime3) )
					SET @Maxtime  = DATEDIFF(MINUTE , @currentHour,convert(time(0),@toTime3));	
			 end
		 end
		if(@Maxtime > @period -@InterApm)
			SET  @Maxtime = @period -@InterApm;
		--select @Maxtime
		if (@Maxtime >15 and @Maxtime <(@period -@InterApm) )
			Insert #tempSchedule values(@facilityID, @scheduleDate,  @currentHour ,@Maxtime ,@currentApm);
		else if @Maxtime =(@period -@InterApm)
			Insert #tempSchedule values(@facilityID, @scheduleDate,  @currentHour ,@Maxtime + 10,@currentApm);
	 end
	--Period 1
	if(@FromTime1 is not null)
	 begin
		SET @ScheduleTime = convert(time(0),@FromTime1);
		While @ScheduleTime  < convert(time(0),@toTime1)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  ApmTime  = @ScheduleTime and
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
			Insert #tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@period -@InterApm,@currentApm);
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
			SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		 End
	 end
	 --Period 2
	 if(@FromTime2 is not null)
	 begin
		 SET @ScheduleTime = convert(time(0),@FromTime2);
		 While @ScheduleTime  < convert(time(0),@toTime2)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  ApmTime  = @ScheduleTime and
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
			Insert #tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@period -@InterApm,@currentApm);
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
			SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		 End
	 end
	 -- Period 3
	 if(@FromTime3 is not null)
	 Begin
		 SET @ScheduleTime = convert(time(0),@FromTime3);
		 While @ScheduleTime  < convert(time(0),@toTime3)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  ApmTime  = @ScheduleTime and
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
			Insert #tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@period -@InterApm,@currentApm);
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
			SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		 End
	end
	--select * ,@NumOfStations MaxApmPerPeriod,(@NumOfStations- CurrentApm) as ApmAvailable, @period as ApmTimeLimit, 'Y' RecordOpt  from #tempSchedule where CurrentApm < @appointPerPeriod
	-- Will Implement Visitor and Inmate record later
	if(@CurrentDate < @scheduleDate)
		select  ScheduleTime,  ApmTimeLimit, @recortOpt as RecordOpt  
		from #tempSchedule where CurrentApm < @NumOfStations  --and ScheduleTime >=  @currentHour 
		and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	else
		select  ScheduleTime,  ApmTimeLimit, @recortOpt as RecordOpt  
		from #tempSchedule where CurrentApm < @NumOfStations and ScheduleTime >=  @currentHour 
		and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	
	--and DATEPART(hh,ScheduleTime) > @hour +1
	drop table #tempSchedule;
END

/*
SET NOCOUNT ON;
	Declare @period smallint, @hour tinyint, @minute tinyint, @year smallint, @AppPerPeriod smallint,@month tinyint,@InterApm int, @currentHour time(0),@MaxTimevisit smallint,@FromTime3 varchar(5), @toTime3 varchar(5);
	Declare	@FromTime1 varchar(5), @toTime1 varchar(5),@FromTime2 varchar(5), @toTime2 varchar(5),@day tinyint, @dw tinyint, @NumOfStations smallint,@timezone smallint,@currentApmTemp smallint,@CurrentDate date,
			@AppointPerStation tinyint, @appointPerPeriod smallint ,@ScheduleTime time(0), @currentApm smallint,@localTime datetime,@flatform tinyint, @recortOpt varchar(1), @Maxtime smallint, @RelationshipID smallint ;
    -- Insert statements for procedure here
    SET @year = DATEPART(YY,@scheduleDate )
    SET @month = DATEPART(M,@scheduleDate )
    SET @day = DATEPART(D,@scheduleDate )
    SET @dw = DATEPART(DW,@scheduleDate )
    SET @MaxTimevisit =0
    SET @currentApm =0
    SET @currentApmTemp =0
    SET @period=15
    SET @recortOpt='Y'
    -- Will get locationID base on ImateID
    select @timezone = timezone,@flatform = flatform  from leg_Icon.dbo.tblfacility where FacilityID =@facilityID 
    SET @hour = DATEPART(HH,GETDATE()) + @timezone
    SET @localTime = DATEADD(hh,@timezone,getdate())
    Select @locationID = locationID,@MaxTimevisit =ISNULL( MaxVisitTime,0) from tblVisitInmateConfig where InmateID =@InmateID  and FacilityID =@facilityID 
	SET  @locationID = ISNULL( @locationID,0)
    SET @currentHour = CONVERT(time(0),@localTime)
    SET @CurrentDate = CONVERT(date,@localTime)
    Select @recortOpt = isnull(recordopt,'Y') ,@RelationshipID = RelationshipID  from tblVisitors where  VisitorID = @VisitorID 
	if(select COUNT(tblInmate.inmateID) from leg_Icon.dbo.tblInmate left join tblVisitInmateConfig on tblInmate.FacilityId = tblVisitInmateConfig.FacilityID and tblInmate.InmateID = tblVisitInmateConfig.InmateID
		where tblInmate.FacilityId = @facilityID and tblInmate.InmateID =@InmateID and SusStartDate <=@scheduleDate and SusEndDate>= @scheduleDate) > 0
		return 0;  
    SELECT @period = isnull(LimitTime,15), @InterApm= InterApm  , @FromTime1= fromTime1, @toTime1 = totime1,@FromTime2= fromTime2, @toTime2 = totime2,@FromTime3 = FromTime3,@toTime3=ToTime3    from [leg_Icon].[dbo].[tblVisitFacilitySchedule]
		where FacilityID = @facilityID and ScheduleDay =@dw and FvisitType =2
	
	--if(@locationID >0)	
	-- begin
		--SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID and LocationID =@locationID
	 --end
	--else
	-- begin
		SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] where FacilityID =@facilityID
	 --end
	 --select @period
	if(@period =0) SET @period =15
	if(@MaxTimevisit >0) SET @period =@MaxTimevisit
	-- remember limittime = limittime + interAmpt time
	if(@period <=60)
		SET @AppointPerStation = 60/(@period )
	else 
		SET @AppointPerStation = (CAST(left(@toTime1,2) as int) - CAST(left(@fromTime1,2) as int))/(@period )
	SET @appointPerPeriod = @AppointPerStation* @NumOfStations
	--select @FromTime1 ,@toTime1,@FromTime2,@toTime2
	Create table #tempSchedule(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), ApmTimeLimit smallint, CurrentApm smallint)
	--select @currentHour 
	if(@RelationshipID in (0,6,7) and @MaxTimevisit=0)
		SET @period = @period * 2
	
	if(select COUNT(*) from [tblVisitEnduserSchedule]  where  (ApmTime  between @currentHour and DATEADD(MINUTE ,@period , @currentHour) or ApmTime  between  DATEADD(MINUTE ,-@period , @currentHour) and @currentHour)  and ApmDate=@scheduleDate) <@NumOfStations

	 begin
		if (@CurrentDate =@scheduleDate)
		 begin
			SET @Maxtime =0
			if(@FromTime1 is not null)
			 begin
				if(@currentHour  >convert(time(0),@fromTime1) and @currentHour < convert(time(0),@toTime1) )
					SET @Maxtime  = DATEDIFF(MINUTE , @currentHour,convert(time(0),@toTime1))
			 end
			if(@FromTime2 is not null)
			 begin
				if(@currentHour  >convert(time(0),@fromTime2) and @currentHour < convert(time(0),@toTime2) )
					SET @Maxtime  = DATEDIFF(MINUTE , @currentHour,convert(time(0),@toTime2))
			 end
			if(@FromTime3 is not null)
			 begin
				if(@currentHour  >convert(time(0),@fromTime3) and @currentHour < convert(time(0),@toTime3) )
					SET @Maxtime  = DATEDIFF(MINUTE , @currentHour,convert(time(0),@toTime3))	
			 end
		 end
		if(@Maxtime > @period -@InterApm)
			SET  @Maxtime = @period -@InterApm
		--select @Maxtime
		if (@Maxtime >15 and @Maxtime <(@period -@InterApm) )
			Insert #tempSchedule values(@facilityID, @scheduleDate,  @currentHour ,@Maxtime ,@currentApm)
		else if @Maxtime =(@period -@InterApm)
			Insert #tempSchedule values(@facilityID, @scheduleDate,  @currentHour ,@Maxtime + 10,@currentApm)
	 end
	--Period 1
	if(@FromTime1 is not null)
	 begin
		SET @ScheduleTime = convert(time(0),@FromTime1)
		While @ScheduleTime  < convert(time(0),@toTime1)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  ApmTime  = @ScheduleTime and
						  LocationID = @locationID and
						  [status] <= 3 
						  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  LocationID = @locationID and
						  ApmTime  = @ScheduleTime 
						  --group by facilityID,ApmDate,ApmDate
			--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
			SET @currentApm =@currentApm + @currentApmTemp
			Insert #tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@period -@InterApm,@currentApm)
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime)
			SET  @ScheduleTime= convert(time(0),@ScheduleTime)
		 End
	 end
	 --Period 2
	 if(@FromTime2 is not null)
	 begin
		 SET @ScheduleTime = convert(time(0),@FromTime2)
		 While @ScheduleTime  < convert(time(0),@toTime2)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  ApmTime  = @ScheduleTime and
						  LocationID = @locationID and
						  [status] <= 3 
						  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  LocationID = @locationID and
						  ApmTime  = @ScheduleTime 
						  --group by facilityID,ApmDate,ApmDate
			--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
			SET @currentApm =@currentApm + @currentApmTemp
			Insert #tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@period -@InterApm,@currentApm)
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime)
			SET  @ScheduleTime= convert(time(0),@ScheduleTime)
		 End
	 end
	 -- Period 3
	 if(@FromTime3 is not null)
	 Begin
		 SET @ScheduleTime = convert(time(0),@FromTime3)
		 While @ScheduleTime  < convert(time(0),@toTime3)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  ApmTime  = @ScheduleTime and
						  LocationID = @locationID and
						  [status] <= 3 
						  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 
						  LocationID = @locationID and
						  ApmTime  = @ScheduleTime 
						  --group by facilityID,ApmDate,ApmDate
			--select @facilityID, @scheduleDate, @ScheduleTime,@currentApm
			SET @currentApm =@currentApm + @currentApmTemp
			Insert #tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@period -@InterApm,@currentApm)
			SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime)
			SET  @ScheduleTime= convert(time(0),@ScheduleTime)
		 End
	end
	--select * ,@NumOfStations MaxApmPerPeriod,(@NumOfStations- CurrentApm) as ApmAvailable, @period as ApmTimeLimit, 'Y' RecordOpt  from #tempSchedule where CurrentApm < @appointPerPeriod
	-- Will Implement Visitor and Inmate record later
	if(@CurrentDate < @scheduleDate)
		select  ScheduleTime,  ApmTimeLimit, @recortOpt as RecordOpt  
		from #tempSchedule where CurrentApm < @NumOfStations  --and ScheduleTime >=  @currentHour 
		and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 )
	else
		select  ScheduleTime,  ApmTimeLimit, @recortOpt as RecordOpt  
		from #tempSchedule where CurrentApm < @NumOfStations and ScheduleTime >=  @currentHour 
		and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 )
	
	--and DATEPART(hh,ScheduleTime) > @hour +1
	drop table #tempSchedule
*/
