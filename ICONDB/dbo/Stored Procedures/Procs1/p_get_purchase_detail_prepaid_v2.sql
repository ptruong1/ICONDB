
CREATE PROCEDURE [dbo].[p_get_purchase_detail_prepaid_v2]
@AccountNo	varchar(12) , -- phone number
@FacilityID	int,
@paymenttypeID	smallint,
@PurchaseAmount	smallmoney,
@TerminalID  varchar(12),
@Fee smallmoney OUTPUT,
@ANI varchar(10) OUTPUT,
@Calltype tinyint OUTPUT

AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2),  @replenishFee  numeric(7,2), @AccountState varchar(2), @FacilityState varchar(2),
	@SetupFee		numeric(7,2) ,@ProcessingFee	numeric(7,2) ;
SET  @SetupFee =0;
SET  @ProcessingFee =0;
SET @FeePercent = 0.05;
SET   @FeeAmount  = 0;
SET  @replenishFee =0;
SET @AccountState = '';
SET  @AccountNo = ltrim(@AccountNo);
Select @ANI = Phone, @FacilityState = [state] from tblfacility with(nolock) where facilityID = @FacilityID;
select @AccountState = StateCode from  tblStates a with(nolock) , tblprepaid b with(nolock)  where a.stateID = b.stateID and b.phoneNo = @AccountNo;
If(@AccountState ='') 
	Select @AccountState = [state] from tblTPM with(nolock) where npa= left(@AccountNo,3);

If(@AccountState = @FacilityState)
	SET @Calltype = 1 ;
else
	SET @Calltype = 0 ;

SET @paymenttypeID =1; --- Modify hardcode all payment with credit card 5/30/2017

If(select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
 Begin
	SET  @SetupFee =5.95;
	If(@TerminalID = 'InmateIVR' or @TerminalID = 'inmateOnline')
		Select  @SetupFee  = ( FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1;
	Else
		Select  @SetupFee  = ( FeeAmount +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1;
 End
Else
 Begin
	SET  @replenishFee =5.95;
	If(@TerminalID = 'InmateIVR' or @TerminalID = 'inmateOnline')
		Select  @replenishFee  = ( FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5;
	else
		Select   @replenishFee  = (FeeAmount +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5;
	
 End
IF (select  count (*)  from tblpaymenttype with(nolock)  where paymenttypeID= @paymenttypeID  and  FeeApplied =1   ) > 0
 Begin
	SELECT  @FeeAmount  = FeeAmount , @FeePercent =  FeePercent  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =3   and  paymenttypeID = @paymenttypeID;
	SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount );
 End
SET  @Fee	=  @ProcessingFee +  @replenishFee 	 +  @SetupFee;

