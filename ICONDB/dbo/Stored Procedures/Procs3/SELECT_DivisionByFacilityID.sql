
CREATE PROCEDURE [dbo].[SELECT_DivisionByFacilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        DivisionID, FacilityID, DepartmentName, ContactPhone1, ContactPhone2, ContactFirstName, ContactLastName, ContactEmail, PINRequired, DayTimeRestrict, 
                         userName, ModifyDate, inputDate
FROM            tblfacilityDivision  with(nolock)
WHERE FacilityID = @FacilityID

