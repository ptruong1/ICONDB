-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_VisitConf_Record] 
	@facilityID int
AS
BEGIN
	
	SET NOCOUNT ON;

    Select *
	FROM [leg_Icon].[dbo].[tblVisitFacilityConfig] where FacilityID = @facilityID
END

