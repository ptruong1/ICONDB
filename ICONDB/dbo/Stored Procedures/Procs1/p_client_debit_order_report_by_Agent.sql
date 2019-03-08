-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_client_debit_order_report_by_Agent] 
@AgentID int,
@fromDate smalldatetime,
@toDate smalldatetime
AS
BEGIN
	select distinct  OrderNo, FacilityID, inmateID, OrderDate, Amount from tblDebitCardOrder with(nolock)  where OrderDate >@fromDate   and OrderDate < dateadd(DAY,1, @toDate)
	and FacilityID in (select facilityID from tblfacility with(nolock) where agentID=@AgentID)
	order by FacilityID, OrderDate
END

