
CREATE PROCEDURE [dbo].[SELECT_DebitAccounts1]

AS
	SET NOCOUNT ON;

SELECT  [AccountNo], [InmateID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], tblStatus.Descrip as Description, FacilityID
FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID

ORDER BY [InputDate] DESC

