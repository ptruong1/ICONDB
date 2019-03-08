

CREATE PROCEDURE [dbo].[DELETE_FreeCalls_Old]
(
	@PhoneNo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblFreePhones] WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))


