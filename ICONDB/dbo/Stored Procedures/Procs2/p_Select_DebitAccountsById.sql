
CREATE PROCEDURE [dbo].[p_Select_DebitAccountsById]
(
	@FacilityID int,
	@AccountNo varchar(12)
)
AS
	SET NOCOUNT ON;

SELECT  [AccountNo], a.InmateID, PIN, a.ActiveDate, a.EndDate, [Balance], [ReservedBalance], a.status, a.Note, a.inputdate, a.modifyDate, a.Username, a.FacilityID, AgentID
FROM tblDebit  a with(nolock) 
				inner join tblInmate b on a.InmateID =b.InmateID and a.FacilityID=b.FacilityId
				inner join tblFacility c on a.FacilityID =c.FacilityID
WHERE a.FacilityID = @FacilityID AND AccountNo = @AccountNo

