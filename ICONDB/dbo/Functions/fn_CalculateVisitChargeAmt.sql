-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_CalculateVisitChargeAmt] 
(
	@facilityID int,
	@VisitType  tinyint,
	@SelectDuration int
)
RETURNS numeric(6,2)

BEGIN
	DECLARE @ServiceFee	numeric(4,2) ,@ChargePerMin	numeric(4,2) ,@MaxVisitTime	smallint ,@TotalCharge	numeric(6,2) 
	SET @ChargePerMin =0;
	SET @ServiceFee =0;
	SET @TotalCharge=0;
	Select @ChargePerMin= PerMinCharge, @ServiceFee= isnull(ConnectFee,0) from tblVisitRate with(nolock)
			where rateID= @facilityID and VisitType =@visitType;
	if (@ChargePerMin is NULL)
			Select @ChargePerMin= PerMinCharge, @ServiceFee= isnull (ConnectFee,0) from tblVisitRate with(nolock)
			where rateID=1 and VisitType =@visitType	;
	
	SET @ChargePerMin= Isnull(@ChargePerMin,0)
	SET @ServiceFee = Isnull(@ServiceFee,0)    
	SET @TotalCharge =  @ServiceFee + @ChargePerMin*@SelectDuration ;
	Return @TotalCharge;

END
