CREATE PROCEDURE  [dbo].[p_prepaid_monthly_fees]

AS


select P.FacilityID, P.Phoneno,P.balance,F.FeeAmount from tblFees F, tblPrepaid P 
where P.FacilityID=F.FacilityID and
 F.feeDetailID=6 and P.FacilityID >0
and P.status=1 and F.FeeAmount >0
