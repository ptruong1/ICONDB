

CREATE PROCEDURE [dbo].[SELECT_DebitAccountsByFacility]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;

SELECT AccountNo, tblDebit.InmateID, tblDebit.ActiveDate as ActiveDate, tblDebit.EndDate as EndDate, Balance, ReservedBalance, tblStatus.Descrip as Description, FirstName, LastName
FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
			INNER JOIN tblInmate with (nolock) ON (tblDebit.InmateID = tblInmate.InmateID and  tblDebit.FacilityID = tblInmate.FacilityID )
			
WHERE tblDebit.FacilityID = @FacilityID  
-- And  tblInmate.InmateID > '0' and tblInmate.Status =1 '10/31/2017
ORDER BY tblDebit.InputDate DESC

