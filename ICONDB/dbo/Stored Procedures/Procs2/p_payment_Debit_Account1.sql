﻿CREATE PROCEDURE [dbo].[p_payment_Debit_Account1]
@AccountNo  varchar(12),
@facilityID int,
@InmateID int,
@CallAmount    numeric(7,2) ,  
@setupFee	numeric(7,2) ,  
@ProcessFee	    numeric(7,2) ,  
@tax		      numeric(7,2) ,  
@paymentTypeID  int , 
@checkNo	VARCHAR(10), 
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccCVV	VARCHAR(4)	,
@BilltoFirstName	VARCHAR(20)	, 
@BillToLastName	VARCHAR(20),  
@BillToEmail	varchar(30),
@BillToAddress	varchar(50),
@BillToCity	varchar(30),
@BillToZip		VARCHAR(5), 
@BillToState	varchar(2),
@BillToCountry	varchar(30),
@MerchantID	varchar(10),
@transactionTime	varchar(25),
@requestID	varchar(24),
@Reasoncode	varchar(5),
@decision	varchar(10),
@authorizationCode	varchar(7),
@ccCaptureReply_reasonCode varchar(3),
@ccCaptureReply_reconciliationID varchar(50),
@UserName	VARCHAR(20)

AS
SET NoCount ON
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) ;
Declare @return_value int, @nextID bigint, @ID bigint, @tblDebitpayments nvarchar(32), @tblTransactionLogs nvarchar(32),@tblpurchase nvarchar(32),@tblWUPrepaid nvarchar(32);
SET  @authAmount = @callAmount + @ProcessFee + @tax + @setupFee;
SET  @LastBalance  = 0;

 if (@paymentTypeID = 4)
 Begin
   	if(select count(*) from  tblWUPrepaid  where CustAcctNo =@AccountNo  ) = 0
   			EXEC   @return_value = p_create_nextID 'tblWUPrepaid', @nextID   OUTPUT
        set           @ID = @nextID ;   
		insert tblWUPrepaid(CustSeqNo,  CustAcctNo,FirstName ,LastName ,Address,City , State, Zip ,Country, Phone,ProcessType,  FacilityID,	   UploadFTP, DownLoadFTP )
		values(@ID, @AccountNo ,@BilltoFirstName	,@BilltoLastName  ,left(@BillToAddress,40) ,@BillToCity , @billToState, @BillToZip,@BillToCountry,@AccountNo ,'A',  @facilityID,	  0, 0) 

 End
Else
 Begin
       EXEC   @return_value = p_create_nextID 'tblTransactionLogs', @nextID   OUTPUT
       set           @ID = @nextID ;    
	Insert tblTransactionLogs (TransactionID, AccountNo,ExpDate, MechantID, Bill_to_country ,Bill_to_Address   ,  Bill_to_city   ,Bill_to_Zip, Bill_to_state, Bill_to_firsName ,Bill_to_lastName    , Bill_to_Email , TransactionTime  ,requestID,
	                		reasonCode, decision,   AuthReply_amount, authorizationCode, ccCaptureReply_reasonCode, ccCaptureReply_reconciliationID, phoneNo)
				Values(@ID,'', @ccExp, @MerchantID,@BillToCountry,@BillToAddress,@BillToCity, @BillToZip, @billToState,@BillToFirstName,@BilltoLastName, @BillToEmail, getdate(),@requestID,
				           @Reasoncode, @decision, @authAmount, @authorizationCode, @ccCaptureReply_reasonCode, @ccCaptureReply_reconciliationID,@AccountNo )
	
	If(@decision = 'ACCEPT'  or   @decision = 'Accept'  or  @decision = 'Approved' or  @decision ='APPROVED' )  
	 BEGIN
	 EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;    
		Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @UserName)
		SET @purchaseID =@ID
		If(@setupFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @setupFee)
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax)
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee)
	
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @CallAmount)

		
		SELECT  @LastBalance =  balance From tblDebit where  AccountNo =  @AccountNo 

		

       EXEC   @return_value = p_create_nextID 'tblDebitpayments', @nextID   OUTPUT
       set           @ID = @nextID ;    
		INSERT INTO tblDebitPayments(paymentID, AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@ID,@AccountNo, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, @checkno,'', @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName	,@userName, getdate(), @purchaseID, @LastBalance)
		UPDATE tblDebit  Set Balance = Balance + @CallAmount ,  ModifyDate = getdate()  where AccountNo =@AccountNo
	 END

 End

--AS
--SET NoCount ON
--declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) 
--SET  @authAmount = @callAmount + @ProcessFee + @tax + @setupFee
--SET  @LastBalance  = 0

-- if (@paymentTypeID = 4)
-- Begin
--   	if(select count(*) from  tblWUPrepaid  where CustAcctNo =@AccountNo  ) = 0
--		insert tblWUPrepaid(  CustAcctNo,FirstName ,LastName ,Address,City , State, Zip ,Country, Phone,ProcessType,  FacilityID,	   UploadFTP, DownLoadFTP )
--		values( @AccountNo ,@BilltoFirstName	,@BilltoLastName  ,left(@BillToAddress,40) ,@BillToCity , @billToState, @BillToZip,@BillToCountry,@AccountNo ,'A',  @facilityID,	  0, 0) 

-- End
--Else
-- Begin

--	Insert tblTransactionLogs ( AccountNo,ExpDate, MechantID, Bill_to_country ,Bill_to_Address   ,  Bill_to_city   ,Bill_to_Zip, Bill_to_state, Bill_to_firsName ,Bill_to_lastName    , Bill_to_Email , TransactionTime  ,requestID,
--	                		reasonCode, decision,   AuthReply_amount, authorizationCode, ccCaptureReply_reasonCode, ccCaptureReply_reconciliationID, phoneNo)
--				Values(@ccNo, @ccExp, @MerchantID,@BillToCountry,@BillToAddress,@BillToCity, @BillToZip, @billToState,@BillToFirstName,@BilltoLastName, @BillToEmail, getdate(),@requestID,
--				           @Reasoncode, @decision, @authAmount, @authorizationCode, @ccCaptureReply_reasonCode, @ccCaptureReply_reconciliationID,@AccountNo )
	
--	If(@decision = 'ACCEPT'  or   @decision = 'Accept'  or  @decision = 'Approved' or  @decision ='APPROVED' )  
--	 BEGIN
--		Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @UserName)
--		SET @purchaseID =SCOPE_IDENTITY()
--		If(@setupFee >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @setupFee)
--		If (@Tax >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax)
		
--		If (@ProcessFee >0) 
--			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee)
	
--		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @CallAmount)

		
--		SELECT  @LastBalance =  balance From tblDebit where  AccountNo =  @AccountNo 

		
--		INSERT INTO tblDebitPayments(AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
--					        Values(@AccountNo, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, @checkno, @ccNo, @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName	,@userName, getdate(), @purchaseID, @LastBalance)
--		UPDATE tblDebit  Set Balance = Balance + @CallAmount ,  ModifyDate = getdate(), [status]=1  where AccountNo =@AccountNo
--	 END

-- End

