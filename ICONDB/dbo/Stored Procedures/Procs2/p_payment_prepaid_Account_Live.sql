


CREATE PROCEDURE [dbo].[p_payment_prepaid_Account_Live]
@AccountNo  varchar(10),
@facilityID int,
@PurchaseAmount    numeric(7,2) ,  
@setupFee	numeric(7,2) ,  
@ProcessFee	    numeric(7,2) ,  
@Tax		      numeric(7,2) ,  
@PaymentTypeID  int ,
@UserName		varchar(25),
@ConfirmID bigint OUTPUT
AS
SET NoCount ON;
DECLARE   @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int;
Declare @return_value int, @nextID bigint, @ID bigint, @tblPrepaidPayments nvarchar(32),  @tblpurchase nvarchar(32) ;
SET  @authAmount = @PurchaseAmount + @ProcessFee + @tax + @setupFee;
SET  @LastBalance  = 0;

if(@PaymentTypeID is null)
	SET @PaymentTypeID =1;

 Begin
		EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ; 
	      	
		Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), 'Live');
		SET @ConfirmID =@ID;
		If(@setupFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 1, @setupFee);
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 4, @Tax);
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 3, @ProcessFee);
	
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 2, 2, @PurchaseAmount);

		
		SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;

		EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
                  set           @ID = @nextID ; 
		INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@ID, @AccountNo, @FacilityID, @authAmount , @PaymentTypeID,@UserName, getdate(), @ConfirmID, @LastBalance);
		
		UPDATE tblPrepaid  Set Balance = Balance + @PurchaseAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo;
	 
		Return @@error;	
 End

