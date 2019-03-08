-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE p_threshold_creditcard_prepaid_report
@day int , 	
@threshold int
AS
BEGIN


select distinct  a.FacilityID, a.InmateName, a.PhoneNo as PrepaidAccount, b.cNum as CreditcardNo,  Isnull(c.UserName,'ByPhone') UserName , count(*) TotalCount , sum(b.ApprovedAmount)  TotalCharge
	 from tblprepaid a with(nolock) inner join Tecodata.dbo.tblBCResponse b with(nolock) on a.PhoneNo = b.cphone  left outer join tblPrepaidPayments c with(nolock) on  b.cphone = c.AccountNo
	 where
	   DATEDIFF(day,b.Transdate, getdate() ) < @day and b.transType =2 and b.statusCode ='0' and b.MerchantProfileID = '000051325420'
	  and DATEDIFF(day,c.PaymentDate, getdate() ) < @day 
	 group by a.FacilityID,a.InmateName, a.PhoneNo, b.cNum, c.UserName 
	 having count(*)  > @threshold
	
END
