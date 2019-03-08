-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_faility_debit_order_by_commissary_report] 
@facilityID int
AS
BEGIN
	select * from  tblDebitCardOrder  where OrderDate >='1/11/2017'  and OrderDate <'2/1/2017' and  FacilityID=@facilityID
	order by OrderNo;
END

