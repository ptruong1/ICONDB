
CREATE PROCEDURE [dbo].[SELECT_DebitAccountsById1]
(
	@FacilityID int,
	@AccountNo varchar(12)
)
AS
	SET NOCOUNT ON;

SELECT  [AccountNo], [InmateID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [inputdate], [modifyDate], [Username], [FacilityID]
FROM tblDebit   with(nolock)
WHERE FacilityID = @FacilityID AND AccountNo = @AccountNo

