CREATE PROCEDURE [dbo].[p_select_ContactPhone]
(
	@ToNo varchar(18)
	
)
AS
	SET NOCOUNT ON;
select C.FacilityID, C.InmateID, RecordID,FromNo, ToNo, ContactName = firstName +' ' + lastName  
from tblCallsBilled C inner join tblPrepaid P on C.ToNo =P.PhoneNo
where ToNo = @ToNo
and P.LastName <>'For Prepaid' and P.FirstName <> 'ICON Transfer';
