

CREATE PROCEDURE [dbo].[p_payment_prepaid_Account_old]
@AccountNo  varchar(10),
@facilityID int,
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
@BillToCity	varchar(24),
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
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) 
SET  @authAmount = @callAmount + @ProcessFee + @tax + @setupFee
SET  @LastBalance  = 0

 if (@paymentTypeID = 4)
 Begin
   	if(select count(*) from  tblWUPrepaid  where CustAcctNo =@AccountNo  ) = 0
		insert tblWUPrepaid(  CustAcctNo,FirstName ,LastName ,Address,City , State, Zip ,Country, Phone,ProcessType,  FacilityID,	   UploadFTP, DownLoadFTP )
		values( @AccountNo ,left(@BilltoFirstName,16)	,@BilltoLastName  ,left(@BillToAddress,40) ,@BillToCity , @billToState, @BillToZip,@BillToCountry,@AccountNo ,'A',  @facilityID,	  0, 0) 

 End
Else
 Begin

	Insert tblTransactionLogs ( AccountNo,ExpDate, MechantID, Bill_to_country ,Bill_to_Address   ,  Bill_to_city   ,Bill_to_Zip, Bill_to_state, Bill_to_firsName ,Bill_to_lastName    , Bill_to_Email , TransactionTime  ,requestID,
	                		reasonCode, decision,   AuthReply_amount, authorizationCode, ccCaptureReply_reasonCode, ccCaptureReply_reconciliationID, phoneNo)
				Values(@ccNo, @ccExp, @MerchantID,@BillToCountry,@BillToAddress,@BillToCity, @BillToZip, @billToState,@BillToFirstName,@BilltoLastName, @BillToEmail, getdate(),@requestID,
				           @Reasoncode, @decision, @authAmount, @authorizationCode, @ccCaptureReply_reasonCode, @ccCaptureReply_reconciliationID,@AccountNo )
	
	If(@decision = 'ACCEPT'  or   @decision = 'Accept' )  
	 BEGIN
		Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @UserName)
		SET @purchaseID =SCOPE_IDENTITY()
		If(@setupFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @setupFee)
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax)
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee)
	
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @CallAmount)

		
		SELECT  @LastBalance =  balance From tblprepaid where  phoneNo =  @AccountNo 

		
		INSERT INTO tblPrepaidPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@AccountNo, @FacilityID, @authAmount , @PaymentTypeID, @checkno, @ccNo, @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName	,@userName, getdate(), @purchaseID, @LastBalance)
		UPDATE tblPrepaid  Set Balance = Balance + @CallAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo
	 END

 End
