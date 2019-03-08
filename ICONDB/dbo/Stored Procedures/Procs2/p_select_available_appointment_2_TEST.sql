-- =============================================
-- Author:		Paul>
-- Modify date: 2/2/2017>
-- Description:	<get available visit schedule>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment_2_TEST]  --------------------Schedule from prepaid side
	@facilityID	int,
	@locationID int,
	@InmateID	varchar(12),
	@scheduleDate	smalldatetime,
	@VisitorID	int	,
	@VisitType  tinyint
		
AS
BEGIN
	
	
	SET NOCOUNT ON;
	Declare @period smallint, @hour tinyint, @minute tinyint, @year smallint, @AppPerPeriod smallint,@month tinyint,@InterApm int,@flatform tinyint, @LocationName varchar(30), @LegacyDate datetime;
	Declare @MaxTimevisit int, @LocLimitTime smallint, @InmateLimitTime smallint,@DayLimitTime smallint, @RelationShipID tinyint, @ExtID varchar(15), @Atlocation varchar(30);
	Declare	@FromTime1 varchar(5), @toTime1 varchar(5),@FromTime2 varchar(5), @toTime2 varchar(5), @FromTime3 varchar(5), @toTime3 varchar(5), @MaxFTime smallint, @MaxInmteTime smallint;
	Declare @day tinyint, @dw tinyint, @NumOfStations smallint,@timezone smallint,@currentApmTemp smallint,@RecordOpt char(1),@Curenttime time(0),@SusStartDate date,@SusEndDate date , @availStaion smallint;
	Declare	@AppointPerStation tinyint, @appointPerPeriod smallint ,@ScheduleTime time(0), @currentApm smallint,@localTime datetime, @ApmIncrement tinyint, @hourBeforeVisit smallint, @MinTimeVisit tinyint, @VisitPerDay tinyint,@VisitPerWeek tinyint, @VisitPerMonth tinyint ;
    Declare @InmateStations smallint, @VisitorStations smallint,  @toTime4 varchar(5),@FromTime4 varchar(5), @HourAllowSchedule smallint, @HourAdvance smallint;
	Declare @return_value smallint, @Gender varchar(1);
    Declare @tempSchedule table(facilityID int , ScheduleDate smalldatetime, ScheduleTime time(0), CurrentApm smallint) ;

	Declare @VisitorVisitPerDay tinyint, @VisitorVisitPerWeek tinyint, @VisitorVisitPerMonth tinyint, @VisitorVisitPerDayPerInmate  tinyint ,@VisitorVisitPerWeekPerInmate tinyint, @VisitorVisitPerMonthPerInmate tinyint;

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
	SET @InmateStations  =0;
	SET @VisitorStations  =0;
	SET  @LegacyDate = getdate();
	SET @VisitorVisitPerDay =0;
	SET  @VisitorVisitPerWeek =0; 
	SET @VisitorVisitPerMonth =0; 
	SET @VisitorVisitPerDayPerInmate =0;
	SET  @VisitorVisitPerWeekPerInmate =0; 
	SET @VisitorVisitPerMonthPerInmate =0;
    
	if (dbo.fn_determine_off_schedule_date (@facilityID, @scheduleDate) > 0)
		goto SelectOUT;

    select @timezone = timezone from leg_Icon.dbo.tblfacility with(nolock) where FacilityID =@facilityID ;
   
    SET @hour = DATEPART(HH,@LegacyDate) + @timezone;
    SET @localTime = DATEADD(hh,@timezone,@LegacyDate);
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
	SET @Atlocation ='';
	SET @Gender ='M';
	-----------------------get configure by Facility
	Select  @MinTimeVisit = Isnull(MinDuration,0) ,
			@ApmIncrement =isnull(Increment,0), 
			@MaxTimevisit = isnull(MaxDuration,@MaxTimevisit)  ,
			@hourBeforeVisit = HourBeforeVisit,
			@InterApm = isnull(InterSection,0) ,
			@VisitPerDay = isnull(VisitPerDay,0), 
			@VisitPerWeek=isnull(VisitPerWeek,0) ,
			@VisitPerMonth=isnull(VisitPerMonth,0) ,
			@HourAllowSchedule =isnull( HourAllowSchedule,720) ,
			@RecordOpt = isnull (RecordOpt,'Y'),
			@VisitorVisitPerDay = isnull(VisitorVisitPerDay,0), 
			@VisitorVisitPerWeek = isnull(VisitorVisitPerWeek,0),
			@VisitorVisitPerMonth = isnull(VisitorVisitPerMonth,0),
			@VisitorVisitPerDayPerInmate = isnull(VisitorVisitPerDayPerInmate,0),
			@VisitorVisitPerWeekPerInmate = isnull(VisitorVisitPerWeekPerInmate,0),
			@VisitorVisitPerMonthPerInmate= isnull(VisitorVisitPerMonthPerInmate,0)
			
			from tblVisitFacilityConfig with(nolock) where FacilityID =@facilityID ;
	
	--select @ApmIncrement, @InterApm;
	SET  @HourAdvance = datediff(hour,@localtime, @scheduleDate);
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
	if ( @RelationShipID in( 0,7,8,9,10))
		SET @hourBeforeVisit =1;
	Else
	 begin
		if(@VisitorVisitPerDay >0 and  [dbo].[fn_check_visitor_visit_allow_per_day] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDay) = 0)
			goto SelectOUT;
		if(@VisitorVisitPerDayPerInmate >0 and  [dbo].[fn_check_visitor_visit_allow_per_day_per_inmate] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDayPerInmate, @InmateID) = 0)
			goto SelectOUT;
		if(@VisitorVisitPerWeek >0 and  [dbo].[fn_check_visitor_visit_allow_per_week] (@facilityID ,@visitorID,	@scheduleDate ,@VisitorVisitPerWeek) = 0)
			goto SelectOUT;
		if(@VisitorVisitPerWeekPerInmate >0 and  [dbo].[fn_check_visitor_visit_allow_per_week_per_inmate] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDayPerInmate, @InmateID) = 0)
			goto SelectOUT;
		if(@VisitorVisitPerMonth >0 and  [dbo].[fn_check_visitor_visit_allow_per_month] (@facilityID ,@visitorID,	@scheduleDate ,@VisitorVisitPerMonth) = 0)
			goto SelectOUT;
		if(@VisitorVisitPerMonthPerInmate >0 and  [dbo].[fn_check_visitor_visit_allow_per_month_per_inmate] (@facilityID ,	@visitorID,	@scheduleDate ,@VisitorVisitPerDayPerInmate, @InmateID) = 0)
			goto SelectOUT;
	 end
	
	if(CHARINDEX('|', @InmateID) >0)
		SET @InmateID = SUBSTRING(@InmateID,1,CHARINDEX('|', @InmateID)-1);

   select  @Gender = SEX from tblInmate with(nolock) where FacilityId = @facilityID and InmateID = @InmateID ;

	---------------------------------------------------get configure by Inmate 
	Select  @locationID = isnull(locationID,0),
			@InmateLimitTime  = isnull(MaxVisitTime,0),
			@VisitPerDay =  (CASE WHEN VisitPerDay = 0 THEN @VisitPerDay WHEN  VisitPerDay is NULL THEN @VisitPerDay Else VisitPerDay END),  
			@VisitPerWeek=   (CASE WHEN VisitPerWeek = 0 THEN @VisitPerWeek WHEN  VisitPerWeek is NULL THEN @VisitPerWeek Else VisitPerWeek END) ,
			@VisitPerMonth= (CASE WHEN VisitPerMonth = 0 THEN @VisitPerMonth WHEN  VisitPerMonth is NULL THEN @VisitPerMonth Else VisitPerMonth END) ,
			@ExtID = ExtID,
			@SusStartDate = SusStartDate, 
			@SusEndDate = SusEndDate, 
			@Atlocation = isnull(Atlocation,'')
		FROM tblVisitInmateConfig with(nolock) where InmateID =@InmateID  and FacilityID =@facilityID ;
	
	--------------------Get Visit Configure at by location -----

	Select 	@InmateLimitTime  =ISNULL(LimitTime,@InmateLimitTime), 
			@MinTimeVisit = Isnull(LimitTime,@MinTimeVisit) ,
				@VisitPerDay = (CASE WHEN VPerDay = 0 THEN @VisitPerDay WHEN  VPerDay is NULL THEN @VisitPerDay Else VPerDay END),  
				@VisitPerWeek=(CASE WHEN VPerWeek = 0 THEN @VisitPerWeek WHEN  VPerWeek is NULL THEN @VisitPerWeek Else VPerWeek END) ,
				@VisitPerMonth=(CASE WHEN VperMonth = 0 THEN @VisitPerMonth WHEN  VperMonth  is NULL THEN @VisitPerMonth Else VperMonth END) 			
		FROM tblVisitLocation with(nolock) where LocationID = @locationID  and FacilityID =@facilityID ;




---------------------Hardcode for Fresno not allow schedule from prepaid side
	if((@facilityID =352 and @VisitType=1) or @HourAdvance > @HourAllowSchedule)
	 begin
		goto SelectOUT;
	 end
----  ---------------------hard code from Kane DA -- Allow them use remote scheduke

--select @VisitPerDay, @VisitPerWeek, @VisitPerMonth

	if(@RelationshipID not in (0,8,7,9,10))
	 BEGIN
	    if( @SusStartDate is not null and @SusEndDate is not null and  @SusStartDate <= @scheduleDate and  @scheduleDate <= @SusEndDate)
			goto SelectOUT;
		if (@VisitPerDay is not NULL and @VisitPerDay >0)
		 begin
			If ((dbo.fn_determine_inmate_visit_per_day (@facilityID ,	@InmateID ,	@scheduleDate, @VisitPerDay )) =0)
			 begin
				goto SelectOUT;
			 end
		 end 	
		if (@VisitPerWeek is not NULL and @VisitPerWeek >0)
		 begin
			If ((dbo.fn_determine_inmate_visit_per_week (@facilityID ,	@InmateID ,	@scheduleDate, @VisitPerWeek )) =0)
			 begin				
				goto SelectOUT;
			 end
		 end 	
		If(@VisitPerMonth  is not NULL and @VisitPerMonth >0)
		 begin
			If ((dbo.fn_determine_inmate_visit_per_month (@facilityID ,	@InmateID ,	@scheduleDate, @VisitPerMonth )) =0)
				goto SelectOUT;
		 end
	 END
	 -------- New Modify
	 
	 EXEC	@return_value = [dbo].[p_get_video_schedule_by_cell]
							@facilityID ,
							@ExtID,
							@dw,
							@VisitType,
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
							@VisitType,
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
							@VisitType,
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
							@VisitType,
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
    
	if (@facilityID =803 and @RelationShipID in (8,7))
	 begin
		SET @VisitType = 1;
		SET @hourBeforeVisit=0;
		SET @VisitPerDay = 0;
		SET @VisitPerWeek=0 ;
		SET	@VisitPerMonth=0;
		SET @RecordOpt ='N';
		EXEC	@return_value = [dbo].[p_get_video_schedule_by_facility_by_relationship]
							@facilityID ,
							@locationID,
							@dw,
							@VisitType,
							@RelationShipID,
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
	 end

    if(@return_value =0 )
		goto SelectOUT;
  
	select @NumOfStations = [dbo].[fn_get_number_station] (	@FacilityID,@locationID ,@ExtID   ,	@visitType) ;

	--select @NumOfStations ;
 	

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
	--SELECT @InmateLimitTime ,  @LocLimitTime  , @DayLimitTime;
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
	if( @NumOfStations>0)
	 Begin
		
		if(@FromTime1 is not null)
		 begin
		  -- select 'TEST1'
			SET @ScheduleTime = convert(time(0),@FromTime1);	

			While @ScheduleTime  <convert(time(0),@toTime1)
			 begin
				SET @currentApm =0;		
				
				SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
				
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
       
				SET @availStaion= @availStaion -  @currentApm; 

				
				if(@availStaion >0)
					Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
				SET @ScheduleTime = dateadd(mi,@period + @InterApm,@ScheduleTime);
				SET  @ScheduleTime= convert(time(0),@ScheduleTime);

				--select @facilityID, @scheduleDate, @ScheduleTime,@availStaion;
				if( @ScheduleTime ='00:00:00')
					Break;
			 End
		 end
		 -- Period 2
		if(@FromTime2 is not null)
		  begin
			--select 'TEST';
			 SET @ScheduleTime = convert(time(0),@FromTime2);
			 While @ScheduleTime  < convert(time(0),@toTime2)
			 begin
				SET  @currentApm =0;		
				
				SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
				
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
       
				SET @availStaion= @availStaion -  @currentApm; 

				if(@availStaion >0)
					Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
				SET @ScheduleTime = dateadd(mi,@period + @InterApm,@ScheduleTime);
				SET  @ScheduleTime= convert(time(0),@ScheduleTime);
				--select @facilityID, @scheduleDate, @ScheduleTime,  @currentApm, @availStaion;
				if( @ScheduleTime ='00:00:00')
					Break;
			 End 
		  end
		 ---- Period 3
		 if(@FromTime3 is not null)
		  begin
			 SET @ScheduleTime = convert(time(0),@FromTime3);
			 While @ScheduleTime  < convert(time(0),@toTime3)
			 begin
				SET  @currentApm =0;		
				
				SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
				
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
       
				SET @availStaion= @availStaion -  @currentApm; 

				if(@availStaion >0)
					Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
				SET @ScheduleTime = dateadd(mi,@period + @InterApm,@ScheduleTime);
				SET  @ScheduleTime= convert(time(0),@ScheduleTime);
				if( @ScheduleTime ='00:00:00')
					Break;
			 End 
		 end
		  ---- Period 4
		 if(@FromTime4 is not null)
		  begin
			 SET @ScheduleTime = convert(time(0),@FromTime4);
			 While @ScheduleTime  < convert(time(0),@toTime4)
			 begin
				SET  @currentApm =0;		
				
				SET @currentApm = dbo.fn_determine_num_of_apm_at_schedule_time (@facilityID ,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@VisitType );
				
				SET @availStaion = [dbo].[fn_determine_num_of_kiosk_by_schedule_time] (@facilityID  , @scheduleDate, @locationID ,	@ScheduleTime, @NumOfStations,@VisitType);
       
				SET @availStaion= @availStaion -  @currentApm; 

				if(@availStaion >0)
					Insert @tempSchedule values(@facilityID, @scheduleDate, @ScheduleTime,@availStaion);
				SET @ScheduleTime = dateadd(mi,@period+ @InterApm,@ScheduleTime);
				SET  @ScheduleTime= convert(time(0),@ScheduleTime);
				if( @ScheduleTime ='00:00:00')
					Break;
			 End 
		 end
	 end
	SelectOUT:
	
	if(@VisitType =1 and @InterApm =0 ) SET @InterApm  =5; -- it is waitining time

	If (@MinTimeVisit> @MaxTimevisit) SET @MaxTimevisit = @MinTimeVisit;

	--select  @hourbeforevisit, DATEADD(Hour,@hourbeforevisit, @localTime) 
	--select *    from @tempSchedule;
	
	If(@MaxTimevisit=  @MinTimeVisit )

		select  ScheduleTime, @MinTimeVisit  as ApmTimeMin ,  @MaxTimevisit as ApmTimeLimit , @ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
			from @tempSchedule where DATEADD(MINUTE,DATEPART(MINUTE,ScheduleTime),   DATEADD(HOUR,DATEPART(HOUR,ScheduleTime), ScheduleDate)) >= DATEADD(Hour,@hourbeforevisit, @localTime) 
			and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );
	Else
	 begin
		Declare @ApmTimeLimit int;		
		SET @ApmTimeLimit = @MaxTimevisit - @InterApm  + (@ApmIncrement +1);
		if(@ApmTimeLimit > @MaxTimevisit) SET @ApmTimeLimit = @MaxTimevisit +1;

		select  ScheduleTime, @MinTimeVisit    as ApmTimeMin,   @ApmTimeLimit   as ApmTimeLimit ,@ApmIncrement as ApmIncrement, @RecordOpt as  RecordOpt 
		from @tempSchedule where  DATEADD(hh,DATEPART(hh,ScheduleTime), ScheduleDate) >= DATEADD(Hour,@hourbeforevisit, @localTime) 
		and ScheduleTime not in (select apmtime from [leg_Icon].[dbo].[tblVisitEnduserSchedule] where (InmateID=@InmateID or VisitorID =@visitorID) and ApmDate = @scheduleDate and status <4 );

	end 
	
END

