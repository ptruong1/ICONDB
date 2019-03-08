

CREATE PROCEDURE [dbo].[SELECT_DebitAccounts]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;

SELECT  [AccountNo], [InmateID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], tblStatus.Descrip as Description
FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
WHERE FacilityID = @FacilityID
ORDER BY [InputDate] DESC


