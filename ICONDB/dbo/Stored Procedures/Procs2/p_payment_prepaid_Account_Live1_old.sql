


CREATE PROCEDURE [dbo].[p_payment_prepaid_Account_Live1_old]
@AccountNo  varchar(10),
@facilityID int,
@PurchaseAmount    numeric(7,2) ,  
@setupFee	numeric(7,2) ,  
@ProcessFee	    numeric(7,2) ,  
@Tax		      numeric(7,2) ,  
@PaymentTypeID  int ,
@UserName		varchar(25),
@ConfirmID bigint OUTPUT,
@LastBalance smallmoney OUTPUT,
@NewBalance smallmoney OUTPUT
AS
SET NoCount ON;
DECLARE   @authAmount	numeric(7,2), @EnduserID int;
SET  @authAmount = @PurchaseAmount + @ProcessFee + @tax + @setupFee;
SET  @LastBalance  = 0;


 Begin           
	
		Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), 'Live');
		SET @ConfirmID =SCOPE_IDENTITY();
		If(@setupFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 1, @setupFee);
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 4, @Tax);
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 3, @ProcessFee);
	
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 2, 2, @PurchaseAmount);

		if(@@error =0)
		 begin
			SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;

		
			INSERT INTO tblPrepaidPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@AccountNo, @FacilityID, @authAmount , @PaymentTypeID,@UserName, getdate(), @ConfirmID, @LastBalance);
		
			UPDATE tblPrepaid  Set Balance = Balance + @PurchaseAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo;
		 end 
		if(@@error =0)
			SET @NewBalance = @LastBalance + @PurchaseAmount;
		else
			SET @NewBalance = @LastBalance;
		
		Return @@error;	
 End

