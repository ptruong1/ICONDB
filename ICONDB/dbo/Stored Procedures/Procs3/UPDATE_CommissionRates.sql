

CREATE PROCEDURE [dbo].[UPDATE_CommissionRates]
(
	@FacilityID int,
	@AgentID int,
	@BillType char(2),
	@Calltype char(2),
	@CommRate numeric(6, 4),
	@PifPaid bit,
	@Descript varchar(50),
	@username varchar(25)
)
AS
	SET NOCOUNT OFF;
UPDATE [tblCommRate] SET [CommRate] = @CommRate, [PifPaid] = @PifPaid, [Descript] = @Descript, [username] = @username, [modifyDate] = getdate() WHERE (([FacilityID] = @FacilityID) AND ([AgentID] = @AgentID) AND ([BillType] = @BillType) AND ([Calltype] = @Calltype))


