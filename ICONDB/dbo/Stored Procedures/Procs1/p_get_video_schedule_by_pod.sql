-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_video_schedule_by_pod]
 @facilityID int,
 @AtLocation varchar(25),
 @ScheduleDate smalldatetime,
 @VisitType tinyint,
 @period smallint OUTPUT,
 @InterApm  smallint OUTPUT,
 @FromTime1 varchar(5) OUTPUT,
 @toTime1 varchar(5) OUTPUT,
 @FromTime2 varchar(5) OUTPUT,
 @toTime2  varchar(5) OUTPUT,
 @FromTime3  varchar(5) OUTPUT,
 @toTime3   varchar(5) OUTPUT,
 @FromTime4  varchar(5) OUTPUT,
 @toTime4   varchar(5) OUTPUT,
 @LocLimitTime smallint OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	Declare  @PodID varchar(15),  @dw tinyint, @Week tinyint;
	EXEC	@Week = [dbo].[p_determine_week_even]  @ScheduleDate ;
	SET  @FromTime1 ='';
	SET  @FromTime2 ='';
	SET  @FromTime3 ='';
	SET  @FromTime4='';
	SET @dw = DATEPART(DW,@scheduleDate );
	--select  @PodID;
	if(@facilityID =747)
	 begin
		SET @PodID= rtrim(substring(@AtLocation,10,5));
		if(CHARINDEX( 'S',@PodID,1) =2)
			SET @PodID = left(@PodID,2);
		Else if(left(@PodID,1) ='C' or left(@PodID,1) ='K' )
		 begin
			if(left(@PodID,1) ='C')
			 begin
				SET @PodID = left(@PodID,4);
				SET @Week = [dbo].[fn_determine_crazy_week] (@ScheduleDate) ;
			 end
			else
				SET @Week = [dbo].[fn_determine_crazy_week_k] (@ScheduleDate) ;
		 end
		Else-- if(left(@PodID,1) <>'K')
			SET @PodID = left(@PodID,1);
	 end
	else
	 begin
		SET @PodID= left(@AtLocation,10);
		if(left(@AtLocation,6)= 'MJ, 02')
			set @PodID = 'MJ, 02';
	 end
	--select @PodID;
	SELECT @period = isnull(LimitTime,@period), @InterApm= isnull(InterApm,@InterApm)  , 
		   @FromTime1= isnull(fromTime1,''), @toTime1 = isnull(totime1,''),
		    @FromTime2= isnull(FromTime2,''), @toTime2=isnull(toTime2,''),
			 @FromTime3= isnull(fromTime3,''), @toTime3 = isnull(totime3,''),
			 @FromTime4= isnull(fromTime4,''), @toTime4 = isnull(totime4,''), 
			 @LocLimitTime= isnull(LimitTime,@LocLimitTime)   
			 from [leg_Icon].[dbo].[tblVisitPodSchedule] with(nolock)
				   where FacilityID = @facilityID and PodID =@PodID and scheduleday= @dw and visitType =@VisitType and (WeekInd= @Week or WeekInd is null) ;
	 

   if(@FromTime1='')
		if(@FromTime2='')
			 if(@FromTime3='')
				 if(@FromTime4='')
					return 0;
  
  return 1;
END

