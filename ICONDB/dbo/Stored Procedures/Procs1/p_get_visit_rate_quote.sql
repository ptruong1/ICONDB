-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_rate_quote]
	@facilityID int,
	@visitType	tinyint
	
AS
DECLARE @ServiceFee	numeric(4,2) ,
	@ChargePerMin	numeric(4,2) ,
	@MaxVisitTime	smallint ,
	@TotalCharge	numeric(4,2) ;
SET @MaxVisitTime =30;
BEGIN
	
	Select @ChargePerMin= PerMinCharge,@ServiceFee= ConnectFee from leg_Icon.dbo.tblVisitRate 
			where rateID= @facilityID and VisitType =@visitType;
	if (@ChargePerMin is NULL)
			Select @ChargePerMin= PerMinCharge,@ServiceFee= ConnectFee from leg_Icon.dbo.tblVisitRate 
			where rateID=1 and VisitType =@visitType	;
			
    SELECT @MaxVisitTime =   [LimitTime]    
	FROM [tblVisitFacilitySchedule] where facilityID = @facilityID	;
	SET @TotalCharge = @ServiceFee + @MaxVisitTime * @ChargePerMin;
	SELECT @ServiceFee as ServiceFee, @ChargePerMin as ChargePerMin,@MaxVisitTime as MaxVisitTime, @TotalCharge as TotalCharge ;
END

