
CREATE PROCEDURE [dbo].[p_get_purchase_debit_ProcessingFee]
@FacilityID	int,
@paymenttypeID	smallint,
@PurchaseAmount	numeric(7,2), 
@ProcessingFee	numeric(7,2) output

AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2),  @replenishFee  numeric(7,2) 

SET  @ProcessingFee =0

SET @FeePercent = 0.05
SET   @FeeAmount  = 0
SET  @replenishFee =5.95;
SET @paymenttypeID = 1; -- Hardcode  for credit card only
Select   @replenishFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5
IF (select  count (*)  from tblpaymenttype with(nolock)  where paymenttypeID= @paymenttypeID  and  FeeApplied =1   ) > 0
 Begin
	SELECT  @FeeAmount  = FeeAmount , @FeePercent =  FeePercent  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =3   and  paymenttypeID = @paymenttypeID
	SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount )
 End
SET  @ProcessingFee	=  @ProcessingFee	 +  @replenishFee

