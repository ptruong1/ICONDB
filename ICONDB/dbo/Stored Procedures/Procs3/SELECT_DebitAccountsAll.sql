
CREATE PROCEDURE [dbo].[SELECT_DebitAccountsAll]

AS
	SET NOCOUNT ON;

SELECT AccountNo, tblDebit.InmateID, tblDebit.ActiveDate as ActiveDate, tblDebit.EndDate as EndDate, Balance, ReservedBalance, tblStatus.Descrip as Description, FirstName, LastName, tblDebit.FacilityID
FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
			INNER JOIN tblInmate with (nolock) ON tblDebit.InmateID = tblInmate.InmateID and
		   	tblDebit.facilityID = tblInmate.facilityID

ORDER BY tblDebit.InputDate DESC

