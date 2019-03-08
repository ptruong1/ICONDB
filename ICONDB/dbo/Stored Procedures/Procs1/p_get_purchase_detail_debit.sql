
CREATE PROCEDURE [dbo].[p_get_purchase_detail_debit]
@InmateID	varchar(12) , 
@FacilityID	int,
@paymenttypeID	smallint,
@PurchaseAmount	smallmoney

AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2),  @replenishFee  numeric(7,2),@SetupFee		numeric(7,2) ,@ProcessingFee	numeric(7,2) ,@tax	numeric(7,2),@AccountNo varchar(12)  ;
SET  @SetupFee =0;
SET  @ProcessingFee =0;
SET @tax =0;
SET @FeePercent = 0.05;
SET   @FeeAmount  = 0;
SET  @replenishFee =0;
SET  @InmateID = ltrim(@InmateID);
SET @paymenttypeID = 1; -- Hardcode  for credit card only
if(@FacilityID =0 or @FacilityID is null)
	SET @FacilityID =1;
SELECT @AccountNo = AccountNo from tblDebit with(nolock) where FacilityID = @FacilityID and InmateID = @InmateID ;
If(select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
 Begin
	SET  @SetupFee =5.95;
	Select  @SetupFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =1;
 End
Else
 Begin
	SET  @replenishFee =5.95;
	Select   @replenishFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =5;
 End
IF (select  count (*)  from tblpaymenttype with(nolock)  where paymenttypeID= @paymenttypeID  and  FeeApplied =1   ) > 0
 Begin
	SELECT  @FeeAmount  = FeeAmount , @FeePercent =  FeePercent  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =3   and  paymenttypeID = @paymenttypeID;
	SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount );
 End
SET  @ProcessingFee	=  @ProcessingFee	 +  @replenishFee;
Select  @tax	  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID = @facilityID and   FeeDetailID =4;

Select @SetupFee as SetupFee, @ProcessingFee as ProcessingFee , @tax as Tax;
