

CREATE PROCEDURE [dbo].[SELECT_LocationByDivisionID]
(@DivisionID int)
AS
	SET NOCOUNT ON;
SELECT        LocationID, DivisionID, Descript, DayTimeRestrict, PINrequired, UserName, ModifyDate, Inputdate
FROM            tblFacilityLocation  with(nolock)
WHERE DivisionID = @DivisionID;

