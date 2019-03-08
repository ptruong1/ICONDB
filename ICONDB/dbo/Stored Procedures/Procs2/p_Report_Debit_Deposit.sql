-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_Debit_Deposit]
@FacilityID int,
@FromDate	date,
@ToDate     date
AS
BEGIN
	select ('#' + a.AccountNo) as AccountNo,c.InmateID , (d.FirstName + ' ' + d.LastName) as InmateName, 
	(CASE a.ProcessedBy when (select clientID from tblClientUsers where siteID = @FacilityID) then 'By Kiosk' else 'By Legacy' end ) as ProcessedBy ,a.PurchaseDate,b.Amount 
	from tblPurchase   a with(nolock) , 	tblPurchaseDetail b with(nolock), tblDebit c with(nolock), tblInmate d with(nolock)
	 where a.PurchaseNo=b.PurchaseNo and 
			a.AccountNo =c.AccountNo  and 
			c.FacilityID = d.FacilityId and
			c.InmateID  = d.InmateID and
			b.Detailtype =2 and 
			a.PurchaseDate >=  @FromDate and a.PurchaseDate <=@ToDate  
			and c.FacilityID =@FacilityID;
END

