

CREATE PROCEDURE [dbo].[UPDATE_BadDebt]
(
	@FacilityID int,
	@AgentID int,
	@BillType char(2),
	@Calltype char(2),
	@Rate numeric(4, 2),
	@username varchar(25)
)
AS
	SET NOCOUNT OFF;
UPDATE [tblBadDebt] SET [Rate] = @Rate, [username] = @username, [modifyDate] = getdate() WHERE (([FacilityID] = @FacilityID) AND ([AgentID] = @AgentID) AND ([BillType] = @BillType) AND ([Calltype] = @Calltype))


