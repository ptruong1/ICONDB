


CREATE PROCEDURE [dbo].[INSERT_CommissionRates]
(
	@FacilityID int,
	@BillType char(2),
	@Calltype char(2),
	@CommRate numeric(4, 2),
	@PifPaid bit,
	@Descript varchar(50),
	@username varchar(25)
)
AS
	DECLARE @AgentID int;
	SET @AgentID = 0;
	SELECT @AgentID = AgentID FROM tblFacility WHERE FacilityID = @FacilityID;
	SET NOCOUNT OFF;
INSERT INTO [tblCommRate] ([FacilityID], [AgentID], [BillType], [Calltype], [CommRate], [PifPaid], [Descript], [username]) VALUES (@FacilityID, @AgentID, @BillType, @Calltype, @CommRate, @PifPaid, @Descript, @username);
	



