

CREATE PROCEDURE [dbo].[p_Report_Debit_payments]
@FacilityID  int,
@fromDate	smalldatetime,
@toDate	smalldatetime

 AS

select  AccountNo ,InmateID , Amount , tblpaymentType.Descript , UserName as RecieverName  , PaymentDate, Note             from tblDebitPayments with(nolock), tblpaymentType with(nolock)
	where   tblDebitPayments.PaymentTypeID =  tblpaymentType.PaymentTypeID and
	 FacilityID = @FacilityID and  PaymentDate >=@fromDate and PaymentDate < @toDate


