

CREATE PROCEDURE [dbo].[SELECT_DebitAccountByAccountNo]
(
	@AccountNo varchar(12),
	@FacilityID int
)
AS
	SET NOCOUNT ON;

If  (@FacilityID > 1)

	SELECT  [AccountNo], [InmateID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], tblStatus.Descrip as Description
	FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
	WHERE FacilityID = @FacilityID AND AccountNo = @AccountNo
else
	
	SELECT  [AccountNo], [InmateID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], tblStatus.Descrip as Description
	FROM tblDebit   with(nolock)  INNER JOIN tblStatus  with(nolock) ON tblDebit.status = tblStatus.statusID
	WHERE  AccountNo = @AccountNo
