
CREATE PROCEDURE [dbo].[SELECT_FacilityKeyWords]
(
	@FacilityId int
)
AS
	SET NOCOUNT ON;
(SELECT Keywords, UserName, AlertEmail, AlertCellPhones FROM tblFacilityKeywords WHERE FacilityID = @FacilityId)

