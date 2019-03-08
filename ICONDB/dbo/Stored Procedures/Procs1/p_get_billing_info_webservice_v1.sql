CREATE PROCEDURE [dbo].[p_get_billing_info_webservice_v1] 
	@AccountNo varchar(12)
AS
BEGIN
 SET NOCOUNT ON;
	select a.FirstName,a.LastName, a.Address,a.City,a.state, a.ZipCode, b.Email,a.Balance, Country = dbo.fn_GetCountryNameByStateID(a.StateID) from tblprepaid a, tblEndusers b where 
	a.EndUserID=b.EndUserID and  PhoneNo=@AccountNo;
END