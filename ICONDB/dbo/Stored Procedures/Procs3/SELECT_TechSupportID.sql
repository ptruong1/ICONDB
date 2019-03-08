
CREATE PROCEDURE [dbo].[SELECT_TechSupportID]
AS
	SET NOCOUNT ON;
SELECT        TechID, Company
FROM            tblFacilityTechInfo  with(nolock)
ORDER BY TechID DESC

