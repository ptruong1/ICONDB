


CREATE PROCEDURE [dbo].[p_payment_prepaid_Account_Live1]
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
Declare @return_value int, @nextID bigint, @ID bigint, @tblPrepaidPayments nvarchar(32),  @tblpurchase nvarchar(32) ;

if(@PaymentTypeID is null)
	SET @PaymentTypeID =1;

SET  @authAmount = @PurchaseAmount + @ProcessFee + @tax + @setupFee;
SET  @LastBalance  = 0;


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

		if(@@error =0)
		 begin
			SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;

		    
             EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
                  set           @ID = @nextID ;  
			INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@ID, @AccountNo, @FacilityID, @authAmount , @PaymentTypeID,@UserName, getdate(), @ConfirmID, @LastBalance);
		
			UPDATE tblPrepaid  Set Balance = Balance + @PurchaseAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo;
		 end 
		if(@@error =0)
			SET @NewBalance = @LastBalance + @PurchaseAmount;
		else
			SET @NewBalance = @LastBalance;
		
		Return @@error;	
 End

--SET NoCount ON;
--DECLARE   @authAmount	numeric(7,2), @EnduserID int;
--SET  @authAmount = @PurchaseAmount + @ProcessFee + @tax + @setupFee;
--SET  @LastBalance  = 0;


-- Begin           
	
--		Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), 'Live');
--		SET @ConfirmID =SCOPE_IDENTITY();

--		if(@@error =0)
--		 Begin
--			SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;

		
--			INSERT INTO tblPrepaidPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
--					        Values(@AccountNo, @FacilityID, @authAmount , @PaymentTypeID,@UserName, getdate(), @ConfirmID, @LastBalance);
		
--			UPDATE tblPrepaid  Set Balance = Balance + @PurchaseAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo;
		 
--		    If(@setupFee >0) 
--				insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 1, @setupFee);
--			If (@Tax >0) 
--			 begin
--				insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 4, @Tax);
--				/*
--				Insert tblTaxesBilled(ReferenceNo, billtype, FedTax, StateTax,LocalTax, BilledDate, BilledStatus, BillToNo,BilledRevenue)
--					Values(@ConfirmID,'10', @Tax, 0, 0, getdate(),0,@AccountNo,@PurchaseAmount );
--					*/
--				EXEC [p_CalculatePrepaidTax] @PurchaseAmount ,@AccountNo,@Tax  ,@ConfirmID ;
--			 end
		
--			If (@ProcessFee >0) 
--				insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 3, @ProcessFee);
	
--			INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 2, 2, @PurchaseAmount);
		 
--		 End 
--		if(@@error =0)
--			SET @NewBalance = @LastBalance + @PurchaseAmount;
--		else
--			SET @NewBalance = @LastBalance;
		
	

--		Return @@error;	
-- End

