

CREATE PROCEDURE [dbo].[p_make_payment_Debit]
@AccountNo  varchar(12),
@facilityID int,
@Amount	  numeric(7,2) ,  
@paymentTypeID  int , 
@checkNo	VARCHAR(10), 
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccZip		VARCHAR(5), 
@ccCVV	VARCHAR(4)	,
@ccFirstName	VARCHAR(20)	, 
@ccLastName	VARCHAR(20),  
@UserName	VARCHAR(20),
 @Note		VARCHAR(50)
AS

If(@Amount >0)
 BEGIN
	Declare @return_value int, @nextID bigint, @ID bigint, @tblpurchase nvarchar(32), @tblDebitPayments nvarchar(32) ;
	EXEC   @return_value = p_create_nextID 'tblDebitPayments', @nextID   OUTPUT
       set           @ID = @nextID ; 
	   
	INSERT INTO tblDebitpayments(paymentID, AccountNo, FacilityID,  Amount  ,     PaymentTypeID, CheckNo  ,   CCNo   ,          CCExp, CCzip ,CCcode ,UserName   , CCFirstName  ,  CCLastName,    PaymentDate   , Note )
	Values  (@ID, @AccountNo, @facilityID,@Amount,  @paymentTypeID, @checkNo	, @ccNo	, @ccExp,@ccZip, @ccCVV	, @UserName, @ccFirstName	, @ccLastName,  getdate(), @Note)

	UPDATE tblDebit  Set Balance = Balance + @Amount  where AccountNo = @AccountNo
 END
