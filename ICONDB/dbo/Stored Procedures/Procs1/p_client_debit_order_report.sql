-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_client_debit_order_report] 
@facilityID int
AS
BEGIN
	select * from  tblDebitCardOrder  where  FacilityID= @facilityID and  OrderDate >='1/3/2018' and OrderDate <'1/31/2018' and  clientID ='ARAMARK' and  FacilityID =@facilityID 
	order by OrderNo;
END

