

CREATE PROCEDURE [dbo].[p_payment_prepaid_Account_service]
@AccountNo  varchar(10),
@facilityID	int,  
@paymentTypeID  int , 
@PurchaseAmount  numeric(7,2),
@setupFee	numeric(7,2) ,  
@ProcessFee	    numeric(7,2) ,  
@tax		      numeric(7,2) ,  
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
@transactionTime	datetime,
@requestID	varchar(24),
@Reasoncode	varchar(5),
@decision	varchar(10),
@authorizationCode	varchar(7),
@ccCaptureReply_reasonCode varchar(3),
@ccCaptureReply_reconciliationID varchar(50),
@UserName	VARCHAR(20)


AS
SET NoCount ON

Declare @authAmount   numeric(7,2), @purchaseID int
Declare  @return_value int, @nextID int, @ID int, @tblpurchaseService nvarchar(32),@tblTransactionLogsService nvarchar(32),@tblPrepaidPaymentService nvarchar(32)  ;
set @authAmount  =0

SET  @authAmount  = @setupFee + @ProcessFee+  @tax + @PurchaseAmount 



 Begin
	If(@decision = 'ACCEPT'  or   @decision = 'Accept' )  
	  Begin
	   
		 EXEC   @return_value = p_create_nextID 'tblpurchaseService', @nextID   OUTPUT
			set           @ID = @nextID ;    
		Insert tblpurchaseService(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @UserName)
		SET @purchaseID =@ID
		If(@setupFee >0) 
			
			insert tblpurchasedetailService( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @setupFee)
		If (@Tax >0) 
			insert tblpurchasedetailService( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax)
		
		If (@ProcessFee >0) 
			insert tblpurchasedetailService( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee)
	    
	    
		INSERT  tblpurchasedetailService( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount)
		
		 EXEC   @return_value = p_create_nextID 'tblPrepaidPaymentSerVice', @nextID   OUTPUT
			set           @ID = @nextID ;
		INSERT INTO tblPrepaidPaymentSerVice(paymentID, purchaseNo, AccountNo, SetupFee,ProcessFee,Tax,  Amount   ,  facilityID,   PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate,note,CCAddress,status)
					        Values(@ID, @purchaseID , @AccountNo,@setupFee,@ProcessFee, @Tax,  @PurchaseAmount  , @facilityID, @PaymentTypeID, @ccNo, @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName,@userName, getdate(), @decision,@BillToAddress,1)

	 End
		else
		begin
				EXEC   @return_value = p_create_nextID 'tblPrepaidPaymentSerVice', @nextID   OUTPUT
				set           @ID = @nextID ;
				INSERT INTO tblPrepaidPaymentSerVice(paymentID,purchaseNo, AccountNo, SetupFee,ProcessFee,Tax,  Amount   ,  facilityID,   PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate,note,CCAddress,status)
								Values(@ID, @purchaseID , @AccountNo,@setupFee,@ProcessFee, @Tax, @PurchaseAmount  , @facilityID, @PaymentTypeID, @ccNo, @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName,@userName, getdate(), @decision,@BillToAddress,0)
		 end

 End
   EXEC   @return_value = p_create_nextID 'tblTransactionLogsService', @nextID   OUTPUT
			set           @ID = @nextID ;
Insert   tblTransactionLogsService (TransactionID ,AccountNo,ExpDate, MechantID, Bill_to_country ,Bill_to_Address   ,  Bill_to_city   ,Bill_to_Zip, Bill_to_state, Bill_to_firsName ,Bill_to_lastName    , Bill_to_Email , TransactionTime  ,requestID,
	                		reasonCode, decision,   AuthReply_amount, authorizationCode, ccCaptureReply_reasonCode, ccCaptureReply_reconciliationID, phoneNo)
				Values(@ID, @ccNo, @ccExp, @MerchantID,@BillToCountry,@BillToAddress,@BillToCity, @BillToZip, @billToState,@BillToFirstName,@BilltoLastName, @BillToEmail, getdate(),@requestID,
				           @Reasoncode, @decision,  @authAmount, @authorizationCode, @ccCaptureReply_reasonCode, @ccCaptureReply_reconciliationID,@AccountNo )

