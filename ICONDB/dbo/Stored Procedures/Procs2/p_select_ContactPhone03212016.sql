CREATE PROCEDURE [dbo].[p_select_ContactPhone03212016]
(
	@ToNo varchar(18)
	
)
AS
	SET NOCOUNT ON;
select C.FacilityID, C.InmateID, InmateName = I.FirstName + ' ' + I.LastName, RecordID,FromNo, ToNo, ContactName = P.FirstName +' ' + P.LastName  
from tblCallsBilled C inner join tblPrepaid P on C.ToNo =P.PhoneNo
				    inner join tblInmate I on C.InmateID = I.InmateID and C.facilityID = I.facilityID
where ToNo = @ToNo and I.status = '1'
and P.LastName <>'For Prepaid' and P.FirstName <> 'ICON Transfer';
