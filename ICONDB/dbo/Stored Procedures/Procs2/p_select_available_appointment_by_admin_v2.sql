-- =============================================
-- Author:		<Author,,Name>
-- Modify date: <2/20/2019>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment_by_admin_v2]--------------------------------------------------For On-side only--- Schedule in ICON
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
	Declare @period smallint, @hour tinyint, @minute tinyint, @year smallint, @AppPerPeriod smallint,@month tinyint,@InterApm int, @LocationName varchar(30),@MaxTimevisit smallint, @MaxFTime smallint, @MaxInmateTime smallint ,  @MinTimeVisit smallint;
	Declare	@FromTime1 varchar(5), @toTime1 varchar(5),@FromTime2 varchar(5), @toTime2 varchar(5), @FromTime3 varchar(5), @toTime3 varchar(5),@day tinyint, @dw tinyint, @NumOfStations smallint,@timezone smallint,@currentApmTemp smallint,@RecordOpt char(1),@Curenttime time(0),
			@AppointPerStation tinyint, @appointPerPeriod smallint ,@ScheduleTime time(0), @currentApm smallint,@localTime datetime, @ApmIncrement tinyint, @hourBeforeVisit smallint, @ExtID varchar(15), @NumOfVisitorStation smallint;
    Declare @VisitPerDay tinyint,  @VisitPerWeek tinyint,  @VisitPerMonth tinyint,@InmateLimitTime tinyint, @VisitRemain smallint, @RelationshipID tinyint,@CurrentDate date, @availStaion smallint, @RateQuotaPerMonth smallint, @SusStartDate date,@SusEndDate date;
    -- Insert statements for procedure here
	Declare @FromTime4 varchar(5) , @toTime4 varchar(5), @Atlocation varchar(30), @LocLimitTime smallint, @VisitType  tinyint, @visitLocationID int;
	Declare @return_value smallint, @Gender varchar(1);
	Declare @tempSchedule  as typeVisitAvailSchedule;
	Declare @VisitorVisitPerDay tinyint, @VisitorVisitPerWeek tinyint, @VisitorVisitPerMonth tinyint, @VisitorVisitPerDayPerInmate  tinyint ,@VisitorVisitPerWeekPerInmate tinyint, @VisitorVisitPerMonthPerInmate tinyint;
	
	SET @return_value =0 ;
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
	SET @VisitType =1;
	SET @Gender  ='M';  
	SET @visitLocationID =0;  
	if (dbo.fn_determine_off_schedule_date (@facilityID, @scheduleDate) > 0)
	 begin
		EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
		return;
	 end
    -- Will get locationID base on ImateID
    select @timezone = timezone  From leg_Icon.dbo.tblfacility with(nolock) where FacilityID =@facilityID ;
    Select  @hourBeforeVisit = isnull(HourBeforeVisitOnSite,0),
			@ApmIncrement= isnull(Increment,0),
			@MaxFTime=isnull(MaxDuration,0), 
			@InterApm = isnull(InterSection,0),
			@VisitPerDay = isnull(VisitPerDay,0), 
			@VisitPerWeek=isnull(VisitPerWeek,0),
			@VisitPerMonth=isnull(VisitPerMonth,0),
			@MinTimeVisit= isnull(MinDuration,MaxDuration) , 
			@RecordOpt = isnull (RecordOpt,'Y')  ,
			@VisitorVisitPerDay = isnull(VisitorVisitPerDay,0), 
			@VisitorVisitPerWeek = isnull(VisitorVisitPerWeek,0),
			@VisitorVisitPerMonth = isnull(VisitorVisitPerMonth,0),
			@VisitorVisitPerDayPerInmate = isnull(VisitorVisitPerDayPerInmate,0),
			@VisitorVisitPerWeekPerInmate = isnull(VisitorVisitPerWeekPerInmate,0),
			@VisitorVisitPerMonthPerInmate= isnull(VisitorVisitPerMonthPerInmate,0) 
		From tblVisitfacilityConfig with(nolock) where FacilityID =@facilityID ;
    SET @hour = DATEPART(HH,GETDATE()) + @timezone;
    SET @localTime = DATEADD(hh,@timezone,getdate());
    SET  @locationID = ISNULL( @locationID,0);
	SET  @Atlocation  ='';
	SET @Curenttime= CONVERT(time(0),@localTime);
	SET @CurrentDate = CONVERT(date,@localTime);
	If (@ApmIncrement =0 )
		SET @MinTimeVisit = @MaxFTime;
	--- Monify for Instance visit for Attoney
	
	if(@RecordOpt='Y')
	 begin
		Select @RecordOpt = isnull(RecordOpt,'Y'),@RelationShipID=RelationShipID, 
					@VisitorVisitPerDay= isnull(PerDay,@VisitorVisitPerDay), @VisitorVisitPerDayPerInmate = isnull(PerDayPerInmate,@VisitorVisitPerDayPerInmate),
					@VisitorVisitPerWeek = isnull(PerWeek,@VisitorVisitPerWeek), @VisitorVisitPerWeekPerInmate=isnull(PerWeekPerInmate,@VisitorVisitPerWeekPerInmate),
					 @VisitorVisitPerMonth= isnull(PerMonth,@VisitorVisitPerMonth), @VisitorVisitPerMonthPerInmate= isnull(PerMonthPerInmate,@VisitorVisitPerMonthPerInmate)    
					from  tblVisitors with(nolock) where VisitorID= @VisitorID ;
	 end
	else
	 begin
		Select @RelationShipID=RelationShipID,
				@VisitorVisitPerDay= isnull(PerDay,@VisitorVisitPerDay), @VisitorVisitPerDayPerInmate = isnull(PerDayPerInmate,@VisitorVisitPerDayPerInmate),
					@VisitorVisitPerWeek = isnull(PerWeek,@VisitorVisitPerWeek), @VisitorVisitPerWeekPerInmate=isnull(PerWeekPerInmate,@VisitorVisitPerWeekPerInmate),
					 @VisitorVisitPerMonth= isnull(PerMonth,@VisitorVisitPerMonth), @VisitorVisitPerMonthPerInmate= isnull(PerMonthPerInmate,@VisitorVisitPerMonthPerInmate)    
					from  tblVisitors with(nolock) where VisitorID= @VisitorID ;
	 end
   
	if(@RelationshipID in (0,8,9,10))
		SET @hourBeforeVisit = 0;
	
	Else
	 begin
		if(@VisitorVisitPerDay >0 and  [dbo].[fn_check_visitor_visit_allow_per_day] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDay) = 0)
		 begin
			EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
			return;
		 end
			
		if(@VisitorVisitPerDayPerInmate >0 and  [dbo].[fn_check_visitor_visit_allow_per_day_per_inmate] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDayPerInmate, @InmateID) = 0)
		 begin
			EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
			return;
		 end
		if(@VisitorVisitPerWeek >0 and  [dbo].[fn_check_visitor_visit_allow_per_week] (@facilityID ,@visitorID,	@scheduleDate ,@VisitorVisitPerWeek) = 0)
		 begin
			EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
			return;
		 end
		if(@VisitorVisitPerWeekPerInmate >0 and  [dbo].[fn_check_visitor_visit_allow_per_week_per_inmate] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDayPerInmate, @InmateID) = 0)
		 begin
			EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
			return;
		 end
		if(@VisitorVisitPerMonth >0 and  [dbo].[fn_check_visitor_visit_allow_per_month] (@facilityID ,@visitorID,	@scheduleDate ,@VisitorVisitPerMonth) = 0)
		 begin
			EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
			return;
		 end
		if(@VisitorVisitPerMonthPerInmate >0 and  [dbo].[fn_check_visitor_visit_allow_per_month_per_inmate] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDayPerInmate, @InmateID) = 0)
		 begin
			EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
			return;
		 end
	 end
	
	 
	if(CHARINDEX('|', @InmateID) >0)
		SET @InmateID = SUBSTRING(@InmateID,1,CHARINDEX('|', @InmateID)-1);

		select  @Gender = SEX from tblInmate with(nolock) where FacilityId = @facilityID and InmateID = @InmateID ;
--------------------Get Visit Configure at Inmate level
		Select  @locationID = isnull( locationID,0),
				@InmateLimitTime  =ISNULL(MaxVisitTime,0), 
				@VisitPerDay =  (CASE WHEN VisitPerDay = 0 THEN @VisitPerDay WHEN  VisitPerDay is NULL THEN @VisitPerDay Else VisitPerDay END),  
				@VisitPerWeek=   (CASE WHEN VisitPerWeek = 0 THEN @VisitPerWeek WHEN  VisitPerWeek is NULL THEN @VisitPerWeek Else VisitPerWeek END) ,
				@VisitPerMonth= (CASE WHEN VisitPerMonth = 0 THEN @VisitPerMonth WHEN  VisitPerMonth is NULL THEN @VisitPerMonth Else VisitPerMonth END) ,
				@ExtID = isnull(ExtID,''), @Atlocation  = isnull(atlocation,''),
				@VisitRemain = visitRemain
			FROM tblVisitInmateConfig with(nolock) where InmateID =@InmateID  and FacilityID =@facilityID ;


--------------------Get Visit Configure at location Level-----

		Select  @LocLimitTime  =ISNULL(LimitTime,0), 
				@VisitPerDay =  (CASE WHEN VPerDay = 0 THEN @VisitPerDay WHEN  VPerDay is NULL THEN @VisitPerDay Else VPerDay END),  
			    @VisitPerWeek=   (CASE WHEN VPerWeek = 0 THEN @VisitPerWeek WHEN  VPerWeek is NULL THEN @VisitPerWeek Else VPerWeek END) ,
			    @VisitPerMonth= (CASE WHEN VPerMonth = 0 THEN @VisitPerMonth WHEN  VPerMonth is NULL THEN @VisitPerMonth Else VPerMonth END) 				
		 FROM tblVisitLocation with(nolock) where LocationID = @locationID  and FacilityID =@facilityID ;

	--select  @LocLimitTime , @InmateLimitTime
----------------Get Visit Location------------------
    SET @visitLocationID = [dbo].[fn_get_onsite_visiting_location_by_inmate](@FacilityID ,@InmateID);

	if(@RelationshipID not in (0,8,7,9,10))
    begin
		If(@facilityID =352) --- HARDCODE FOR FRESNO
		 begin
			 if (@VisitRemain =0)
				begin
					EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
					return;
				end
		 end
		else
		 begin
				select @RateQuotaPerMonth = RateQuotaPerMonth from tblvisitRate with(nolock) where RateID= @facilityID and visittype=1; 
				if(@RateQuotaPerMonth =-1)
				 begin
					EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
					return;
				 end
				 
				if( @SusStartDate is not null and @SusEndDate is not null and  @SusStartDate <= @scheduleDate and  @scheduleDate <= @SusEndDate)
				 begin
					EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
					return;
				 end
				if (@VisitPerDay is not NULL and @VisitPerDay >0)
				 begin
					If ((dbo.fn_determine_inmate_visit_per_day (@facilityID ,	@InmateID ,	@scheduleDate, @VisitPerDay )) =0)
					 begin
						EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
						return;
					 end
				 end 	
				if (@VisitPerWeek is not NULL and @VisitPerWeek >0)
				 begin
					If ((dbo.fn_determine_inmate_visit_per_week (@facilityID ,	@InmateID ,	@scheduleDate, @VisitPerWeek )) =0)
					 begin				
						EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
						return;
					end
				 end 	
				If(@VisitPerMonth  is not NULL and @VisitPerMonth >0)
				 begin
					If ((dbo.fn_determine_inmate_visit_per_month (@facilityID ,	@InmateID ,	@scheduleDate, @VisitPerMonth )) =0)
					 begin
						EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
						return;
					 end
				 end
				 
		end
	end
	
  else  ---------------- FOR SPECIAL ONSIDE 
	begin  
	     
	   SELECT @period = isnull(LimitTime,@MaxTimevisit), @InterApm= isnull(InterApm,@InterApm)  , @FromTime1= PriFromTime, @toTime1 = PriTotime, @MaxFTime = isnull(PriLimitTime,@MaxFTime ) from [leg_Icon].[dbo].[tblVisitFacilitySchedule] with(nolock) where facilityID = @facilityID and scheduleday= @dw and FvisitType =1;
	   If ( @FromTime1 <> '' and @toTime1 <>'')
			SET	@return_value =1 ;
	 end
  
   
   
   if (@return_value =0 )
	 EXEC	@return_value = [dbo].[p_get_video_schedule_by_cell]
							@facilityID ,
							@ExtID,
							@dw,
							1 , --@VisitType,
							@period OUTPUT,
							@InterApm OUTPUT,
							 @FromTime1 OUTPUT,
							 @toTime1 OUTPUT,
							@FromTime2 OUTPUT,
							@toTime2 OUTPUT,
							@FromTime3 OUTPUT,
							 @toTime3 OUTPUT,
							@FromTime4 OUTPUT,
							@toTime4 OUTPUT,
							 @LocLimitTime OUTPUT;

 
	if (@return_value =0 and @Atlocation <>'')
		EXEC	@return_value = [dbo].[p_get_video_schedule_by_pod]
							@facilityID ,
							@Atlocation,
							@ScheduleDate,
							1 , --@VisitType,
							 @period OUTPUT,
							@InterApm OUTPUT,
							 @FromTime1 OUTPUT,
							@toTime1 OUTPUT,
							 @FromTime2 OUTPUT,
							@toTime2 OUTPUT,
							@FromTime3 OUTPUT,
							@toTime3 OUTPUT,
							 @FromTime4 OUTPUT,
							 @toTime4 OUTPUT,
							 @LocLimitTime OUTPUT;
	
	if (@return_value =0 and @locationID >0)
		EXEC	@return_value = [dbo].[p_get_video_schedule_by_location]
							@facilityID ,
							@locationID,
							@dw,
							1 , --@VisitType,
							@period OUTPUT,
							@InterApm OUTPUT,
							 @FromTime1 OUTPUT,
							@toTime1 OUTPUT,
							@FromTime2 OUTPUT,
							@toTime2 OUTPUT,
							@FromTime3 OUTPUT,
							@toTime3 OUTPUT,
							@FromTime4 OUTPUT,
							@toTime4 OUTPUT,
							@LocLimitTime OUTPUT;
    if (@return_value =0 and @facilityID >0)
		EXEC	@return_value = [dbo].[p_get_video_schedule_by_facility]
							@facilityID ,
							@locationID,
							@dw,
							1 , --@VisitType,
							@period OUTPUT,
							@InterApm OUTPUT,
							@FromTime1 OUTPUT,
							@toTime1 OUTPUT,
							@FromTime2 OUTPUT,
							@toTime2 OUTPUT,
							@FromTime3 OUTPUT,
							@toTime3 OUTPUT,
							@FromTime4 OUTPUT,
							@toTime4 OUTPUT,
							@LocLimitTime OUTPUT;
	if (@return_value =0 and @facilityID >0)
		EXEC	@return_value = [dbo].[p_get_video_schedule_by_gender]
							@facilityID ,
							@locationID,
							@dw,
							@VisitType,
							@Gender ,
							@period OUTPUT,
							@InterApm OUTPUT,
							@FromTime1 OUTPUT,
							@toTime1 OUTPUT,
							@FromTime2 OUTPUT,
							@toTime2 OUTPUT,
							@FromTime3 OUTPUT,
							@toTime3 OUTPUT,
							@FromTime4 OUTPUT,
							@toTime4 OUTPUT,
							@LocLimitTime OUTPUT; 
 


    if(@return_value =0 )
	 begin
		EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
		return;
	 end

	
	select @NumOfStations = [dbo].[fn_get_number_station] (	@FacilityID,@locationID ,@ExtID   ,	@visitType) ;

    
	if(@MaxFTime >0) set @MaxTimevisit = @MaxFTime;
	
	if(@InmateLimitTime >0)
		SET @MaxTimevisit = @InmateLimitTime;
	else
	 begin
		if (@LocLimitTime >0)
			SET @MaxTimevisit = @LocLimitTime;
	 end
	 SET @period = @MaxTimevisit;

	-- Select @period,@InmateLimitTime, @LocLimitTime

	if(@period =0 or @period  is null) SET @period =15; 
	
	if(@period <=60)
		SET @AppointPerStation = 60/(@period ) ;
	else 
		SET @AppointPerStation = (CAST(left(@toTime1,2) as int) - CAST(left(@fromTime1,2) as int))/(@period ) ;
	SET @appointPerPeriod = @AppointPerStation* @NumOfStations;

	select @ApmIncrement = isnull(Increment,@ApmIncrement) from leg_Icon.dbo.tblVisitRate with(nolock) where RateID =@facilityID ;
	
	SET @MaxTimevisit =  @period  -@InterApm;

	

	SET @ScheduleTime = convert(time(0),@FromTime1);
	--Period 1


	if (@CurrentDate = @scheduleDate ) --- For all people go on site to visit and (@RelationshipID  in (0,7,8,9,10) or )
	 begin	 
		
		Insert @tempSchedule values(@facilityID, @scheduleDate,  @Curenttime ,@currentApm);
		
     end

   
    ----------------------------------------------------------
	While @ScheduleTime  <convert(time(0),@toTime1)
	 begin
		
		SET  @currentApm =0;		
				
		SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
		
		If( @visitLocationID >0)
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time_by_visitLocation] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType,@visitLocationID );
		Else
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
       
		SET @availStaion= @availStaion -  @currentApm; 
       
		
		if(@availStaion > 0)
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
	   
		SET @ScheduleTime = dateadd(mi,@period + @InterApm,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		if( @ScheduleTime ='00:00:00')
		  Break;
	 End
	 -- Period 2
	 SET @ScheduleTime = convert(time(0),@FromTime2);
	 While @ScheduleTime  < convert(time(0),@toTime2)
	 begin
		SET  @currentApm =0;		
				
		SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
				
		If( @visitLocationID >0)
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time_by_visitLocation] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType,@visitLocationID );
		Else
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
  
       
		SET @availStaion= @availStaion -  @currentApm; 

		if(@availStaion > 0)
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
	    -------------------------------End Edit -------------------
		SET @ScheduleTime = dateadd(mi,@period + @InterApm,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		if( @ScheduleTime ='00:00:00')
		  Break;
	 End 
	 
	 ---- Period 3
	 SET @ScheduleTime = convert(time(0),@FromTime3);
	 While @ScheduleTime  < convert(time(0),@toTime3)
	 begin
		SET  @currentApm =0;		
				
		SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
				
		If( @visitLocationID >0)
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time_by_visitLocation] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType,@visitLocationID );
		Else
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
  
       
		SET @availStaion= @availStaion -  @currentApm;  		
		
		if(@availStaion > 0)
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
		
		SET @ScheduleTime = dateadd(mi,@period + @InterApm,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		if( @ScheduleTime ='00:00:00')
		   Break;
	 End 
	 ---- Period 4
	 SET @ScheduleTime = convert(time(0),@FromTime4);
	 While @ScheduleTime  < convert(time(0),@toTime4)
	 begin
		
		SET  @currentApm =0;		
				
		SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
				
		If( @visitLocationID >0)
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time_by_visitLocation] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType,@visitLocationID );
		Else
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
  
       
		SET @availStaion= @availStaion -  @currentApm; 
	
		if(@availStaion > 0)
			Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
		
		SET @ScheduleTime = dateadd(mi,@period+ @InterApm,@ScheduleTime);
		SET  @ScheduleTime= convert(time(0),@ScheduleTime);
		if( @ScheduleTime ='00:00:00')
		   Break;
	 End 
	
	EXEC  p_select_visit_schedule @tempSchedule,@MinTimeVisit ,@MaxTimevisit ,@ApmIncrement,@RecordOpt ,@hourbeforevisit ,@localTime ,@CurrentDate ,@scheduleDate ,	@InmateID ,	@visitorID ,@InterApm ,	@Curenttime ;
	return;
END

