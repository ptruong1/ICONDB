
CREATE PROCEDURE [dbo].[p_get_purchase_detail_test]
@AccountNo	varchar(12) , -- phone number
@FacilityID	int,
@paymenttypeID	smallint,
@PurchaseAmount	numeric(7,2),
@SetupFee		numeric(7,2) output, 
@ProcessingFee	numeric(7,2) output, 
@tax			numeric(7,2) output

AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2),  @replenishFee  numeric(7,2) , @AccountState varchar(2), @FacilityState varchar(2);
SET  @SetupFee =0
SET  @ProcessingFee =0
SET @tax =0
SET @FeePercent = 0.05
SET   @FeeAmount  = 0
SET  @replenishFee =0
SET  @AccountNo = ltrim(@AccountNo)

If(select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
 Begin
	SET  @SetupFee =5.95;
	Select  @SetupFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1;
 End
Else
 Begin
	SET  @replenishFee =5.95;
	Select   @replenishFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5
 End
IF (select  count (*)  from tblpaymenttype with(nolock)  where paymenttypeID= @paymenttypeID  and  FeeApplied =1   ) > 0
 Begin
	SELECT  @FeeAmount  = FeeAmount , @FeePercent =  FeePercent  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =3   and  paymenttypeID = @paymenttypeID;
	SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount )
 End
SET  @ProcessingFee	=  @ProcessingFee	 +  @replenishFee;
select @AccountState=  b.stateCode from tblprepaid a with(nolock) , tblStates b with(nolock) where a.StateID= b.StateID and  phoneno=@AccountNo;
select @FacilityState = [state] from tblfacility with (nolock) where facilityID = @FacilityID; 
if(@AccountState <> @FacilityState)
	Select  @tax	= isnull(Amount,0) +@PurchaseAmount * isnull( Rate,0) from tblTaxes where State ='US';
