
CREATE PROCEDURE [dbo].[DELETE_InmateByPIN1]
(
	@Original_InmateID bigint,
	@Original_FacilityId int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblInmate] WHERE (([InmateID] = @Original_InmateID) AND ([FacilityId] = @Original_FacilityId))

