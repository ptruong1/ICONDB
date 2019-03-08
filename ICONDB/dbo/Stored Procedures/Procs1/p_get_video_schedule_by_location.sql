-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[p_get_video_schedule_by_location]
 @facilityID int,
 @LocationID varchar(15),
 @dw tinyint,
 @VisitType tinyint,
 @period smallint  OUTPUT,
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
	SET  @FromTime1 ='';
	SET  @FromTime2 ='';
	SET  @FromTime3 ='';
	SET  @FromTime4='';

	SELECT @period = isnull(LimitTime,@period), @InterApm= isnull(InterApm,@InterApm)  , 
		   @FromTime1= isnull(fromTime1,''), @toTime1 = isnull(totime1,''),
		    @FromTime2= isnull(FromTime2,''), @toTime2=isnull(toTime2,''),
			 @FromTime3= isnull(fromTime3,''), @toTime3 = isnull(totime3,''),
			 @FromTime4= isnull(fromTime4,''), @toTime4 = isnull(totime4,''), 
			 @LocLimitTime= isnull(LimitTime,@LocLimitTime)   
			 from [leg_Icon].[dbo].[tblVisitLocationSchedule] with(nolock)
					where FacilityID = @facilityID and LocationID =@locationID and scheduleday= @dw and visitType =@VisitType;	
	 

   if(@FromTime1='')
		if(@FromTime2='')
			 if(@FromTime3='')
				 if(@FromTime4='')
					return 0;
  
  return 1;
END

