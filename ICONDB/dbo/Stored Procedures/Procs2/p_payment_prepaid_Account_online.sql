

CREATE PROCEDURE [dbo].[p_payment_prepaid_Account_online]
@AccountNo  varchar(12),
@facilityID int,
@CallAmount    numeric(7,2) ,  
@setupFee	numeric(7,2) ,  
@ProcessFee	    numeric(7,2) ,  
@tax		      numeric(7,2) ,  
@paymentTypeID  int ,
@ConfirmID bigint OUTPUT
AS

SET NoCount ON
declare   @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int;
Declare @return_value int, @nextID bigint, @ID bigint, @tblPrepaidPayments nvarchar(32),  @tblpurchase nvarchar(32);

SET  @authAmount = @callAmount + @ProcessFee + @tax + @setupFee;
SET  @LastBalance  = 0;
if(@PaymentTypeID is null)
	SET @PaymentTypeID =1;


 Begin

	            
	  EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;  
		Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), 'Online')
		SET @ConfirmID =@ID
		If(@setupFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 1, @setupFee);
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 4, @Tax);
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 3, @ProcessFee)
	
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 2, 2, @CallAmount);

		
		SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;

        EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT;
         set           @ID = @nextID ;    
		INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@ID, @AccountNo, @FacilityID, @authAmount , @PaymentTypeID,'Online', getdate(), @ConfirmID, @LastBalance)
		
		UPDATE tblPrepaid  Set Balance = Balance + @CallAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo;
	 
		
 End

--SET NoCount ON;
--declare   @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int;
--SET  @authAmount = @callAmount + @ProcessFee + @tax + @setupFee;
--SET  @LastBalance  = 0;

-- Begin

	            
	
--		Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), 'Online')
--		SET @ConfirmID =SCOPE_IDENTITY();
--		If(@setupFee >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 1, @setupFee)
--		If (@Tax >0) 
--		 begin
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 4, @Tax);
--			EXEC [p_CalculatePrepaidTax] @CallAmount ,@AccountNo,@Tax  ,@ConfirmID ;
--		 end
		
--		If (@ProcessFee >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 1, 3, @ProcessFee) ;
	
--		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @ConfirmID, 2, 2, @CallAmount)

		
--		SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo  ;


--		INSERT INTO tblPrepaidPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
--					        Values(@AccountNo, @FacilityID, @authAmount , @PaymentTypeID,'Online', getdate(), @ConfirmID, @LastBalance) ;
		
--		UPDATE tblPrepaid  Set Balance = Balance + @CallAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo ;
	 
		
-- End

