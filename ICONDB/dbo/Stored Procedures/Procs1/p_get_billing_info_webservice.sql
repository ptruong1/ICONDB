-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_billing_info_webservice] 
	@AccountNo varchar(12)
AS
BEGIN
 SET NOCOUNT ON;
	select a.FirstName,a.LastName, a.Address,a.City,a.state, a.ZipCode, b.Email,a.Balance from tblprepaid a, tblEndusers b where 
	a.EndUserID=b.EndUserID and  PhoneNo=@AccountNo;
END

