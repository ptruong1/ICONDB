
CREATE PROCEDURE [dbo].[INSERT_PayPal_TransactionLog]
@AccountNo  varchar(10),
@CallAmount    numeric(7,2) ,  
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
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
@decision          varchar(10),
@authorizationCode	varchar(7),
@ccCaptureReply_reasonCode varchar(3),
@ccCaptureReply_reconciliationID varchar(50) 




AS
SET NoCount ON

 Begin

	Declare @return_value int, @nextID int, @ID int, @tblTransactionLogs nvarchar(32) ;

       EXEC   @return_value = p_create_nextID 'tblTransactionLogs', @nextID   OUTPUT
       set           @ID = @nextID ;      
	Insert tblTransactionLogs (TransactionID, AccountNo,ExpDate, MechantID, Bill_to_country ,Bill_to_Address   ,  Bill_to_city   ,Bill_to_Zip, Bill_to_state, Bill_to_firsName ,Bill_to_lastName, Bill_to_Email , TransactionTime  ,requestID,
	                		reasonCode, decision,   AuthReply_amount, authorizationCode, ccCaptureReply_reasonCode, ccCaptureReply_reconciliationID, phoneNo)
				Values(@ID,@ccNo, @ccExp, @MerchantID,@BillToCountry,@BillToAddress,@BillToCity, @BillToZip, @billToState,@BillToFirstName,@BilltoLastName, @BillToEmail, @transactionTime,@requestID,
				           @Reasoncode, @decision, @CallAmount, @authorizationCode, @ccCaptureReply_reasonCode, @ccCaptureReply_reconciliationID,@AccountNo )
	
	

	--Insert tblTransactionLogs ( AccountNo,ExpDate, MechantID, Bill_to_country ,Bill_to_Address   ,  Bill_to_city   ,Bill_to_Zip, Bill_to_state, Bill_to_firsName ,Bill_to_lastName, Bill_to_Email , TransactionTime  ,requestID,
	--                		reasonCode, decision,   AuthReply_amount, authorizationCode, ccCaptureReply_reasonCode, ccCaptureReply_reconciliationID, phoneNo)
	--			Values(@ccNo, @ccExp, @MerchantID,@BillToCountry,@BillToAddress,@BillToCity, @BillToZip, @billToState,@BillToFirstName,@BilltoLastName, @BillToEmail, @transactionTime,@requestID,
	--			           @Reasoncode, @decision, @CallAmount, @authorizationCode, @ccCaptureReply_reasonCode, @ccCaptureReply_reconciliationID,@AccountNo )
	
	

 End

