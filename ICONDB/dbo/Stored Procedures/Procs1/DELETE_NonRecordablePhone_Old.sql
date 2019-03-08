CREATE PROCEDURE [dbo].[DELETE_NonRecordablePhone_Old]
(
	@PhoneNo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblNonRecordPhones] WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))
