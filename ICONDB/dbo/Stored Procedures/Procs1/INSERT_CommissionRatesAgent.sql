


CREATE PROCEDURE [dbo].[INSERT_CommissionRatesAgent]
(
	@AgentID int,
	@BillType char(2),
	@Calltype char(2),
	@CommRate numeric(4, 2),
	@PifPaid bit,
	@Descript varchar(50),
	@username varchar(25)
)
AS
	
	SELECT @AgentID = AgentID FROM tblAgent WHERE AgentID = @AgentID;
	SET NOCOUNT OFF;
INSERT INTO [tblCommRateAgent] ([AgentID], [BillType], [Calltype], [CommRate], [PifPaid], [Descript], [username]) VALUES ( @AgentID, @BillType, @Calltype, @CommRate, @PifPaid, @Descript, @username);
	



