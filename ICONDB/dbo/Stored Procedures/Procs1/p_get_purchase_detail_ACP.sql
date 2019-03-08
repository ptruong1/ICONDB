
CREATE PROCEDURE [dbo].[p_get_purchase_detail_ACP]
@AccountNo	varchar(12) , -- phone number
@FacilityID	int OUTPUT,
@paymenttypeID	smallint,
@PurchaseAmount	numeric(7,2),
@SetupFee		numeric(7,2) output, 
@ProcessingFee	numeric(7,2) output, 
@tax			numeric(7,2) output,
@balance		numeric(7,2) output

AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2),  @replenishFee  numeric(7,2) ;
SET  @SetupFee =0;
SET  @ProcessingFee =0;
SET @tax =0;
SET @FeePercent = 0.05;
SET   @FeeAmount  = 0;
SET  @replenishFee =0;
SET  @AccountNo = ltrim(@AccountNo);
SET @FacilityID=1;
SET @balance =0;
SET @paymenttypeID = 1; -- Hardcode  for credit card only
SELECT @FacilityID= facilityID, @balance= balance from tblPrepaid where phoneno =@AccountNo and status =1 ;

If (@FacilityID >0)
Begin

	If(select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
	 Begin
		SET  @SetupFee =3;
		Select  @SetupFee  = ( FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1;
		if(@SetupFee is null)
			SET  @SetupFee =3;
	 End
	Else
	 Begin
		SET  @replenishFee =3;
		Select   @replenishFee  = ( FeeAmountAuto  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5;
		if(@replenishFee is null)
			SET  @replenishFee =3;
	 End
	IF (select  count (*)  from tblpaymenttype with(nolock)  where paymenttypeID= @paymenttypeID  and  FeeApplied =1   ) > 0
	 Begin
		SELECT  @FeeAmount  = FeeAmountAuto , @FeePercent =  FeePercent  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =3   and  paymenttypeID = @paymenttypeID;
		SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount );
	 End
	SET  @ProcessingFee	=  @ProcessingFee	 +  @replenishFee;
	Select  @tax	  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =4;
End
