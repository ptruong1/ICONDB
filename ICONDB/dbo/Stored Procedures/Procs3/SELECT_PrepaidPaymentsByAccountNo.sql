

CREATE PROCEDURE [dbo].[SELECT_PrepaidPaymentsByAccountNo]
(
	@AccountNo varchar(12),
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        paymentID, AccountNo, InmateID, FacilityID, Amount, A.PaymentTypeID, CheckNo, CCNo, CCExp, CCzip, CCcode, UserName, CCFirstName, CCLastName, 
                         PaymentDate, Note, B.Descript as [PaymentTypeName]
FROM            tblPrepaidPayments A INNER JOIN tblpaymentType B ON A.PaymentTypeID = B.paymentTypeID
WHERE        (AccountNo = @AccountNo) AND FacilityID = @FacilityID
ORDER BY PaymentDate DESC
