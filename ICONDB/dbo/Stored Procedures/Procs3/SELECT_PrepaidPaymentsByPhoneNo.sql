


CREATE PROCEDURE [dbo].[SELECT_PrepaidPaymentsByPhoneNo]
(
	@AccountNo varchar(10),
	@FacilityID int
)
AS
	SET NOCOUNT ON;
if(@FacilityID >0)

	SELECT        paymentID, AccountNo, InmateID, FacilityID, Amount, A.PaymentTypeID, CheckNo, CCNo, CCExp, CCzip, CCcode, UserName, CCFirstName, CCLastName, 
							 PaymentDate, Note, B.Descript as [PaymentTypeName]
	FROM            tblPrepaidPayments A INNER JOIN tblpaymentType B ON A.PaymentTypeID = B.paymentTypeID
	WHERE        (AccountNo = @AccountNo) AND FacilityID = @FacilityID
	ORDER BY PaymentDate DESC ;
else
	SELECT        paymentID, AccountNo, InmateID, FacilityID, Amount, A.PaymentTypeID, CheckNo, CCNo, CCExp, CCzip, CCcode, UserName, CCFirstName, CCLastName, 
							 PaymentDate, Note, B.Descript as [PaymentTypeName]
	FROM            tblPrepaidPayments A INNER JOIN tblpaymentType B ON A.PaymentTypeID = B.paymentTypeID
	WHERE        (AccountNo = @AccountNo) 
	ORDER BY PaymentDate DESC ;



