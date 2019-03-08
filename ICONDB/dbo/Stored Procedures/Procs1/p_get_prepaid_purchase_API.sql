CREATE PROCEDURE [dbo].[p_get_prepaid_purchase_API]
@userID	varchar(25),
@password	varchar(25),
@clientID	varchar(10),
@siteID		int,
@siteIP		varchar(16),
@AccountNo	varchar(12) , -- phone number
@paymenttypeID	smallint,
@PurchaseAmount	numeric(7,2)
AS
Declare  @FeePercent  numeric(4,2) ,  @FeeAmount  numeric(4,2),  @replenishFee  numeric(7,2) ,@SetupFee  numeric(7,2) ,@ProcessingFee	numeric(7,2) ,@tax numeric(7,2) ,@replyCode varchar(3), @userlevel tinyint

SET  @SetupFee =0
SET  @ProcessingFee =0
SET @tax =0
SET @FeePercent = 0.05
SET   @FeeAmount  = 0
SET  @replenishFee =0
SET  @AccountNo = ltrim(@AccountNo)
SET @userlevel =0

exec  p_verify_client_info_API @userID	, @password , @clientID	,@siteID		,@siteIP		,@replyCode	 OUTPUT, @userlevel  OUTPUT
if( @replyCode ='000'  or @replyCode ='200'  )
  Begin

	If(select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
	 Begin
		SET  @SetupFee =10.99
		Select  @SetupFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID =@siteID  and   FeeDetailID =1
	 End
	Else
	 Begin
		SET  @replenishFee =5.50
		Select   @replenishFee  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID =@siteID and   FeeDetailID =5
	 End
	IF (select  count (*)  from tblpaymenttype with(nolock)  where paymenttypeID= @paymenttypeID  and  FeeApplied =1   ) > 0
	 Begin
		SELECT  @FeeAmount  = FeeAmount , @FeePercent =  FeePercent  from tblFees with(nolock)  where   FacilityID = @siteID and   FeeDetailID =3   and  paymenttypeID = @paymenttypeID
		SET  @ProcessingFee	  =  @FeeAmount  +  (@FeePercent  * @PurchaseAmount )
	 End
	Select  @tax	  = ( FeeAmount  +  FeePercent  * @PurchaseAmount )  from tblFees with(nolock)  where   FacilityID =@siteID and   FeeDetailID =4
	
	SET  @ProcessingFee	=  @ProcessingFee	 +  @replenishFee  +   @SetupFee +   @tax
	
	
  End
SELECT @replyCode as Authcode,  @AccountNo as PrepaidAcctNumber,   @ProcessingFee	 as  FeeAndTax
