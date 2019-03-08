

CREATE PROCEDURE [dbo].[p_fund_Inmate_Debit_Account_online]
@AccountNo	varchar(12),
@InmateID varchar(12),
@facilityID int,
@FundAmount    numeric(7,2) ,  
@setupFee	numeric(7,2) ,  
@ProcessFee	    numeric(7,2) ,  
@tax		      numeric(7,2) ,  
@paymentTypeID  int ,
@ConfirmID varchar(12) OUTPUT,
@Balance   numeric(7,2) OUTPUT
AS

SET NoCount ON;
declare   @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) ,@DebitAcct varchar(12), @purchaseID bigint;
Declare @return_value int, @nextID bigint, @ID bigint, @tblpurchase nvarchar(32), @tblDebitPayments nvarchar(32) ;

SET  @authAmount = @FundAmount + @ProcessFee + @tax + @setupFee;
SET  @LastBalance  = 0;
SET @paymentTypeID = isnull(@paymentTypeID,1);

 Begin

	    EXEC [p_create_debit_account_with_inmate_Op]
			@facilityID,	@InmateID	,	''  ,	''  ,
			@FundAmount	,	@AccountNo ,	@DebitAcct  OUTPUT, @LastBalance OUTPUT ;        
	 EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT;
       set           @ID = @nextID ;  
		Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @DebitAcct , getdate(), 'Online')
		SET @purchaseID =@ID;
		If(@setupFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @setupFee);
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax);
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee);
	
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @FundAmount);

		--select @Balance = balance from tblDebit where AccountNo =  @DebitAcct;
		SET @Balance =  @LastBalance + @FundAmount;
		EXEC   @return_value = p_create_nextID 'tblDebitPayments', @nextID   OUTPUT;
       set           @ID = @nextID ; 
		INSERT INTO tblDebitPayments(paymentID, AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@ID, @DebitAcct, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, @AccountNo, getdate(), @purchaseID, @LastBalance);
		
		SET @ConfirmID ='D' + CAST (@purchaseID as varchar(12));
		Return @@error;
 
 End

--SET NoCount ON
--declare   @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) ,@DebitAcct varchar(12), @purchaseID bigint
--SET  @authAmount = @FundAmount + @ProcessFee + @tax + @setupFee
--SET  @LastBalance  = 0


-- Begin

--	    EXEC [p_create_debit_account_with_inmate_Op]
--			@facilityID,	@InmateID	,	''  ,	''  ,
--			@FundAmount	,	@AccountNo ,	@DebitAcct  OUTPUT, @LastBalance OUTPUT ;        
	
--		Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@DebitAcct , getdate(), 'Online')
--		SET @purchaseID =SCOPE_IDENTITY()
--		If(@setupFee >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @setupFee)
--		If (@Tax >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax)
		
--		If (@ProcessFee >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee)
	
--		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @FundAmount)

--		--select @Balance = balance from tblDebit where AccountNo =  @DebitAcct;
--		SET @Balance =  @LastBalance + @FundAmount;
--		INSERT INTO tblDebitPayments(AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,UserName ,  PaymentDate, PurchaseNo,LastBalance  )
--					        Values(@DebitAcct, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, @AccountNo, getdate(), @purchaseID, @LastBalance)
		
--		SET @ConfirmID ='D' + CAST (@purchaseID as varchar(12));
--		Return @@error;
 
-- End

