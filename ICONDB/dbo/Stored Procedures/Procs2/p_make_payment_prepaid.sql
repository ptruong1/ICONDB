

CREATE PROCEDURE [dbo].[p_make_payment_prepaid]  --- for icon 
@PhoneNo  varchar(10),
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
	   Declare @return_value int, @nextID bigint, @ID bigint, @tblPrepaidPayments nvarchar(32) ;
       EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
       set           @ID = @nextID ;    
	INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate ,Note )
				        Values(@ID, @PhoneNo, @FacilityID, @Amount, @PaymentTypeID, @checkno, @ccNo, @ccExp,@ccZip, @ccCVV, @ccFirstName,@ccLastName	,@userName, getdate(),@note)
	UPDATE tblPrepaid  Set Balance = Balance + @Amount  where PhoneNo = @PhoneNo
 END

--If(@Amount >0)
-- BEGIN
--	INSERT INTO tblPrepaidPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate ,Note )
--				        Values(@PhoneNo, @FacilityID, @Amount, @PaymentTypeID, @checkno, @ccNo, @ccExp,@ccZip, @ccCVV, @ccFirstName,@ccLastName	,@userName, getdate(),@note)
--	UPDATE tblPrepaid  Set Balance = Balance + @Amount  where PhoneNo = @PhoneNo
-- END

