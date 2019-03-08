-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_video_schedule_by_facility_by_relationship]
 @facilityID int,
 @LocationID varchar(15),
 @dw tinyint,
 @VisitType tinyint,
 @RelationshipID int,
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
	
	declare @PriFromTime  varchar(5),  @PriToTime varchar(5), @PriLimitTime smallint ;
    -- Insert statements for procedure here


	SET @PriLimitTime =0;
	SET  @FromTime1 ='';
	SET  @FromTime2 ='';
	SET  @FromTime3 ='';
	SET  @FromTime4='';

	SELECT @period = isnull(LimitTime,@period), @InterApm= isnull(InterApm,@InterApm)  , 
		   @FromTime1= isnull(fromTime1,''), @toTime1 = isnull(totime1,''),
		    @FromTime2= isnull(FromTime2,''), @toTime2=isnull(toTime2,''),
			 @FromTime3= isnull(fromTime3,''), @toTime3 = isnull(totime3,''),
			 @FromTime4= isnull(fromTime4,''), @toTime4 = isnull(totime4,''), 
			 @LocLimitTime= isnull(LimitTime,@LocLimitTime)   ,@PriLimitTime = PriLimitTime,
			 @PriFromTime = isnull(PriFromTime,''),  @PriToTime = isnull(PriToTime,'')
			 from [leg_Icon].[dbo].[tblVisitFacilitySchedule] with(nolock)
				   where FacilityID = @facilityID and scheduleday= @dw and FvisitType =@VisitType;


   If(@RelationshipID = 8 and  @PriFromTime <>'' and  @PriToTime  <>'')
   begin
		SET @FromTime1=@PriFromTime ;
		SET @toTime1 =  @PriToTime;
		SET  @FromTime2 =null;
		SET  @toTime2 =null;
		SET  @FromTime3 =null;
		SET  @toTime3 =null;
		SET  @FromTime4=null;
		SET  @toTime4 =null;
		SET  @LocLimitTime  = @PriLimitTime;
		return 1;
   end

   if(@FromTime1='')
		if(@FromTime2='')
			 if(@FromTime3='')
				 if(@FromTime4='')
					return 0;
  
  return 1;
END

