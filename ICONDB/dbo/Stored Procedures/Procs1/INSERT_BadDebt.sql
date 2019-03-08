


CREATE PROCEDURE [dbo].[INSERT_BadDebt]
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
INSERT INTO [leg_Icon].[dbo].[tblBadDebt] ([FacilityID], [AgentID], [BillType], [Calltype], [Rate], [username]) VALUES (@FacilityID, @AgentID, @BillType, @Calltype, @Rate, @username);
	



