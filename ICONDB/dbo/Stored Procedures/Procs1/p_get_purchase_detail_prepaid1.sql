
CREATE PROCEDURE [dbo].[p_get_purchase_detail_prepaid1]
@AccountNo	varchar(12) , -- phone number
@FacilityID	int,
@paymenttypeID	smallint,
@PurchaseAmount	smallmoney

AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2),  @replenishFee  numeric(7,2), @AccountState varchar(2), @FacilityState varchar(2),
	@SetupFee		numeric(7,2) ,@ProcessingFee	numeric(7,2) ,@tax			numeric(7,2) ;
SET  @SetupFee =0;
SET  @ProcessingFee =0;
SET @tax =0;
SET @FeePercent = 0.05;
SET   @FeeAmount  = 0;
SET  @replenishFee =0;
SET  @AccountNo = ltrim(@AccountNo);

SET @paymenttypeID =1; --- Modify hardcode all payment with credit card 5/30/2017

If(select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
 Begin
	SET  @SetupFee =3;
	if (select count(*) from tblfacility where FacilityID = @FacilityID  and [state]='AL') >0
		Select  @SetupFee  = ( FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1;
	Else
		Select  @SetupFee  = (FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1;
 End
Else
 Begin
	SET  @replenishFee =3;
	if (select count(*) from tblfacility where FacilityID = @FacilityID  and [state]='AL') >0
		Select   @replenishFee  = (FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5;
	Else
		Select   @replenishFee  = (FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5;
	
 End
IF (select  count (*)  from tblpaymenttype with(nolock)  where paymenttypeID= @paymenttypeID  and  FeeApplied =1   ) > 0
 Begin
	SELECT  @FeeAmount  = FeeAmount , @FeePercent =  FeePercent  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =3   and  paymenttypeID = @paymenttypeID;
	SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount );
 End
SET  @ProcessingFee	=  @ProcessingFee	 +  @replenishFee;


EXEC  [dbo].[p_EstimatePrepaidTax]  @PurchaseAmount,@AccountNo , @Tax   OUTPUT;
/*
select @AccountState=  b.stateCode from tblprepaid a with(nolock) , tblStates b with(nolock) where a.StateID= b.StateID and  phoneno=@AccountNo;
select @FacilityState = [state] from tblfacility with (nolock) where facilityID = @FacilityID; 
if(@AccountState <> @FacilityState)
	Select  @tax	= isnull(Amount,0) +@PurchaseAmount * isnull( Rate,0) from tblTaxes where State ='US';
*/
Select @SetupFee as SetupFee, @ProcessingFee as ProcessingFee , @tax as Tax;
