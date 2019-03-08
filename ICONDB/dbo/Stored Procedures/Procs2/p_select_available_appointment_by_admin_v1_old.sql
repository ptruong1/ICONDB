-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment_by_admin_v1_old]
	@facilityID	int,
	@locationID int,
	@InmateID	varchar(12),
	@scheduleDate	date,
	@VisitorID	int	
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- Modidy on 6/16/15 --- Using for all facility
	SET NOCOUNT ON;
	Declare @period smallint, @hour tinyint, @minute tinyint, @year smallint, @AppPerPeriod smallint,@month tinyint,@InterApm int,@flatform tinyint, @LocationName varchar(30),@MaxTimevisit smallint, @MaxFTime smallint, @MaxInmateTime smallint;
	Declare	@FromTime1 varchar(5), @toTime1 varchar(5),@FromTime2 varchar(5), @toTime2 varchar(5), @FromTime3 varchar(5), @toTime3 varchar(5),@day tinyint, @dw tinyint, @NumOfStations smallint,@timezone smallint,@currentApmTemp smallint,@RecordOpt char(1),@Curenttime time(0),
			@AppointPerStation tinyint, @appointPerPeriod smallint ,@ScheduleTime time(0), @currentApm smallint,@localTime datetime, @ApmIncrement tinyint, @hourBeforeVisit smallint, @ExtID varchar(15), @NumOfVisitorStation smallint;
    Declare @VisitPerDay tinyint,  @VisitPerWeek tinyint,  @VisitPerMonth tinyint,@InmateLimitTime tinyint, @VisitRemain smallint, @RelationshipID tinyint,@CurrentDate date, @availStaion smallint, @RateQuotaPerMonth smallint;
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
	SET @ExtID ='';
	SET @NumOfVisitorStation =1;
    -- Will get locationID base on ImateID
    select @timezone = timezone,@flatform = flatform  from leg_Icon.dbo.tblfacility with(nolock) where FacilityID =@facilityID ;
    Select @hourBeforeVisit = isnull(HourBeforeVisitOnSite,0),@ApmIncrement= isnull(Increment,0),@MaxFTime=isnull(MaxDuration,0),@InterApm = isnull(InterSection,0),@VisitPerDay = isnull(VisitPerDay,0), @VisitPerWeek=isnull(VisitPerWeek,0) ,@VisitPerMonth=isnull(VisitPerMonth,0)    from tblVisitfacilityConfig with(nolock) where FacilityID =@facilityID ;
    SET @hour = DATEPART(HH,GETDATE()) + @timezone;
    SET @localTime = DATEADD(hh,@timezone,getdate());
    SET  @locationID = ISNULL( @locationID,0);
	
	SET @Curenttime= CONVERT(time(0),@localTime);
	SET @CurrentDate = CONVERT(date,@localTime);
	--- Monify for Instance visit for Attoney
	Select @RecordOpt = isnull(recordopt,'Y') ,@RelationshipID = RelationshipID  from tblVisitors with(nolock) where  VisitorID = @VisitorID ;
	if(@RelationshipID in (0,8,9,10))
		SET @hourBeforeVisit = 0;
	--select @ApmIncrement,@InterApm,@MaxTimevisit ;
	--Select @locationID = locationID from tblVisitInmateConfig where InmateID =@InmateID and FacilityID =@facilityID 
	if(CHARINDEX('|', @InmateID) >0)
		SET @InmateID = SUBSTRING(@InmateID,1,CHARINDEX('|', @InmateID)-1);
	--if(@locationID =0) 
	--	Select @locationID = locationID,@MaxInmateTime =ISNULL( MaxVisitTime,@MaxTimevisit),@ExtID = ExtID  from tblVisitInmateConfig where InmateID =@InmateID  and FacilityID =@facilityID ;
		Select @locationID = locationID,
				@InmateLimitTime  =ISNULL(MaxVisitTime,@MaxFTime), 
				@VisitPerDay = isnull(VisitPerDay,@VisitPerDay), 
				@VisitPerWeek=isnull(VisitPerWeek,@VisitPerWeek) ,
				@VisitPerMonth=isnull(VisitPerMonth,@VisitPerMonth) ,
				@ExtID = isnull(ExtID,''),
				@VisitRemain = visitRemain
			FROM tblVisitInmateConfig with(nolock) where InmateID =@InmateID  and FacilityID =@facilityID ;
	--Select @InmateID ,  @locationID, @InmateLimitTime;
	-- Charge for visit Onside
	
	-- EXception for Attoneys
	if(@RelationshipID not in (0,8,7,9,10))
    begin
				select @RateQuotaPerMonth = RateQuotaPerMonth from tblvisitRate with(nolock) where RateID= @facilityID and visittype=1;
				if(@RateQuotaPerMonth =-1)
				 begin
					return 0;
				 end

				if (@VisitPerDay is not NULL and @VisitPerDay >0)
				 begin
					if (select COUNT(*) from tblVisitEnduserSchedule with(nolock) where FacilityID = @facilityID and InmateID = @InmateID and ApmDate = @scheduleDate and status in (2,3,5,8) ) > = @VisitPerDay
					 begin			
						return 0;
					 end
				 end 	
				if (@VisitPerWeek is not NULL and @VisitPerWeek >0)
				 begin
					IF(select  COUNT(*) from tblVisitEnduserSchedule with(nolock) where FacilityID =@facilityID  and  DATEPART(wk,ApmDate) =DATEPART(wk,@scheduleDate) and InmateID =@InmateID and status in(2,3,5,8)) >= @visitPerWeek 
					 begin			
						return 0;
					 end
				 end 	
				If(@VisitPerMonth  is not NULL and @VisitPerMonth >0)
				 begin
					IF(select  COUNT(*) from tblVisitEnduserSchedule with(nolock) where FacilityID =@facilityID  and  DATEPART(MONTH,ApmDate) =DATEPART(MONTH,@scheduleDate) and InmateID =@InmateID and status in(2,3,5,8)) >= @VisitPerMonth 
		
						return 0;
				 end
		 -- end
		 --end
	end
	--- New Edit on 10/22/2015
  else  
	begin  
	     
	   SELECT @period = isnull(LimitTime,@MaxTimevisit), @InterApm= isnull(InterApm,@InterApm)  , @FromTime1= PriFromTime, @toTime1 = PriTotime, @MaxFTime = isnull(PriLimitTime,@MaxFTime ) from [leg_Icon].[dbo].[tblVisitFacilitySchedule] with(nolock) where facilityID = @facilityID and scheduleday= @dw and FvisitType =1;
	
	 end
   ---------- Add Cell Schedule and Location Schedule
    --select @MaxTimevisit;
	if(@FromTime1 is null or @FromTime1='' or @toTime1 is null or @toTime1  ='' )
	 begin
	   if ((select COUNT(*) from tblVisitCellSchedule with(nolock) where FacilityID =@facilityID ) >0  and @ExtID <>'')
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
	 end
	--------------------End new edit--------------------
    --select @period;
	if(@locationID >0)	
	 begin
		SELECT @NumOfStations=  count(*)  FROM [leg_Icon].[dbo].[tblVisitPhone] with(nolock) where FacilityID =@facilityID and LocationID =@locationID;
		--SELECT @LocationName=  LocationName FROM [leg_Icon].[dbo].tblVisitLocation where LocationID = @locationID
	 end
	else
	 begin
		SELECT @NumOfStations=  count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] with(nolock) where FacilityID =@facilityID and StationType=2 ;
		--SET @LocationName='Visit Area'
	 end

	 ------------------------------------------------------------------------------
	--- new edit on 12/2/2015 for limit number of visitor station
	
	Select @NumOfVisitorStation = count(*) FROM [leg_Icon].[dbo].[tblVisitPhone] with(nolock) where FacilityID =@facilityID and StationType=1 ;

    
	---------------------------------------------------------------------------------------------
	-- Make change for Maxduation for some inmate
	if(@MaxFTime >0) set @MaxTimevisit = @MaxFTime;
	If( @MaxInmateTime >0) set @MaxTimevisit= @MaxInmateTime;
	if(@MaxTimevisit >0) set @period =@MaxTimevisit;  
	if(@period =0 or @period  is null) SET @period =15; 
	--select @MaxFTime, @MaxTimevisit,@period,@InterApm; 
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
	--select @CurrentDate, @scheduleDate
	------------------Modify for Attoney or bail ----------------

	if (@CurrentDate = @scheduleDate ) --- For all people go on site to visit and (@RelationshipID  in (0,7,8,9,10) or )
	 begin	 
		--select @MaxTimevisit;
		Insert @tempSchedule values(@facilityID, @scheduleDate,  @Curenttime ,@currentApm);
		
     end
    ----------------------------------------------------------
	While @ScheduleTime  <convert(time(0),@toTime1)
	 begin
		if(@locationID > 0)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule]  with(nolock)
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
		  end
	    else
		  begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule]  with(nolock)
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 						  
						 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
						  [status] <= 3 and visitType =1;
					  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 						  		  
						  ApmTime  = @ScheduleTime and visitType =1;
						  --group by facilityID,ApmDate,ApmDate
		  end	

		SET @currentApm =@currentApm + @currentApmTemp;
		--------- New Edit for share station with something else on 11/3/2015
		
		
		if(select count(*) from tblVisitCellSchedule with(nolock)  where facilityID = @facilityID and locID = @locationID and ScheduleDay=  datepart(dw,  @scheduleDate)) > 0
		   begin
			   select  @NumOfStations= count( ExtID) from tblVisitCellSchedule  with(nolock) where 
						 ScheduleDay=  datepart(dw,  @scheduleDate) and FacilityID=@facilityID and VisitType=1  and locid =@locationID
						  and FromTime1  <= @ScheduleTime and ToTime1 >= @ScheduleTime ;


		   end
        if(@NumOfVisitorStation < @NumOfStations)
			set @availStaion= @NumOfVisitorStation;
		else
			set @availStaion=  @NumOfStations;

		SET @availStaion= @availStaion -  @currentApm; 
       -- select @facilityID, @scheduleDate, @ScheduleTime,@currentApm,@availStaion; 
		
		if(@availStaion > 0)
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
	    -------------------------------End Edit -------------------
		SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
	 End
	 -- Period 2
	 SET @ScheduleTime = convert(time(0),@FromTime2);
	 While @ScheduleTime  < convert(time(0),@toTime2)
	 begin
		if(@locationID > 0)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule]  with(nolock)
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
		  end
	    else
		  begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule]  with(nolock)
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 						  
						 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
						  [status] <= 3 and visitType =1;
					  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 						  		  
						  ApmTime  = @ScheduleTime and visitType =1;
						  --group by facilityID,ApmDate,ApmDate
		  end	
		SET @currentApm =@currentApm + @currentApmTemp;
		--------- New Edit for share station with something else on 11/3/2015

		if(select count(*) from tblVisitCellSchedule with(nolock)  where facilityID = @facilityID and locID = @locationID and ScheduleDay=  datepart(dw,  @scheduleDate)) > 0
		 begin  
			select @NumOfStations= count( ExtID) from tblVisitCellSchedule with(nolock) where 
					 ScheduleDay=  datepart(dw,  @scheduleDate) and FacilityID=@facilityID and VisitType=1  and locid =@locationID
					  and FromTime2  <= @ScheduleTime and ToTime2 >= @ScheduleTime ;
		 end
		if(@NumOfVisitorStation < @NumOfStations)
			set @availStaion= @NumOfVisitorStation;
		else
			set @availStaion=  @NumOfStations;

		SET @availStaion= @availStaion -  @currentApm; 

		if(@availStaion > 0)
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
	    -------------------------------End Edit -------------------
		SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
	 End 
	 
	 ---- Period 3
	 SET @ScheduleTime = convert(time(0),@FromTime3);
	 While @ScheduleTime  < convert(time(0),@toTime3)
	 begin
		if(@locationID > 0)
		 begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] with(nolock)
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
		  end
	    else
		  begin
			select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] with(nolock)
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 						  
						 (ApmTime >= @ScheduleTime and ApmTime< DATEADD(MINUTE,LimitTime,@ScheduleTime)) and					  
						  [status] <= 3 and visitType =1;
					  
			select @currentApmTemp= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] 
					where FacilityID = @facilityID and
						  ApmDate  = @scheduleDate and 						  		  
						  ApmTime  = @ScheduleTime and visitType =1;
						  --group by facilityID,ApmDate,ApmDate
		  end	
		SET @currentApm =@currentApm + @currentApmTemp;
		--------- New Edit for share station with something else on 11/3/2015
		SET @availStaion = @NumOfStations;
		if(select count(*) from tblVisitCellSchedule with(nolock)  where facilityID = @facilityID and locID = @locationID and ScheduleDay=  datepart(dw,  @scheduleDate)) > 0
		 begin  
		   select @NumOfStations= count( ExtID) from tblVisitCellSchedule with(nolock) where 
					 ScheduleDay=  datepart(dw,  @scheduleDate) and FacilityID=@facilityID and VisitType=1  and locid =@locationID
					  and FromTime3  <= @ScheduleTime and ToTime3 >= @ScheduleTime ;
			
		 end
		
		if(@NumOfVisitorStation < @NumOfStations)
			set @availStaion= @NumOfVisitorStation;
		else
			set @availStaion= @NumOfStations;

		SET @availStaion= @availStaion -  @currentApm; 
		
		-- select @facilityID, @scheduleDate, @ScheduleTime,@currentApm, @availStaion;
		if(@availStaion > 0)
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
		-------------------------------End Edit -------------------
		SET @ScheduleTime = dateadd(mi,@period,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
	 End 
	-- select * from @tempSchedule
	--select * ,@NumOfStations MaxApmPerPeriod,(@NumOfStations- CurrentApm) as ApmAvailable, @period as ApmTimeLimit, 'Y' RecordOpt  from #tempSchedule where CurrentApm < @appointPerPeriod
	-- Will Implement Visitor and Inmate record later
	SelectOUT:
	
	select @ApmIncrement = Increment from leg_Icon.dbo.tblVisitRate with(nolock) where RateID =@facilityID ;
	--select @RecordOpt = isnull(RecordOpt,'Y') from leg_Icon.dbo.tblVisitors where VisitorID= @VisitorID ; 
	--- // setup   @period -@InterApm 
	if(@CurrentDate < @scheduleDate)
		select  ScheduleTime,@period -@InterApm as ApmTimeMin,  @period  -@InterApm  as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
		from @tempSchedule where  DATEADD(MI,DATEPART(HOUR ,ScheduleTime) *60 +   DATEPART(MI ,ScheduleTime), ScheduleDate) >= DATEADD(Hour,@hourbeforevisit, @localTime) 
		and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	else
	 begin
		if( @InterApm  < 15)
			select  ScheduleTime,@period -@InterApm  as ApmTimeMin,  @period -@InterApm   as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
				from @tempSchedule where ScheduleTime >= @Curenttime 
				and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
		else
			select  ScheduleTime,@period -@InterApm  as ApmTimeMin,  @period -@InterApm   as ApmTimeLimit,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
				from @tempSchedule where  ScheduleTime >= Dateadd(MINUTE,@InterApm, @Curenttime) 
				and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	 end
END

