

CREATE PROCEDURE [dbo].[UPDATE_DivisionByDivisionID]
(
	@FacilityID int,
	@DepartmentName varchar(50),
	@ContactPhone1 char(10),
	@ContactPhone2 char(10),
	@ContactFirstName varchar(20),
	@ContactLastName varchar(50),
	@ContactEmail varchar(25),
	@PINRequired bit,
	@DayTimeRestrict bit,
	@userName varchar(25),
	@DivisionID int
)
AS
	SET NOCOUNT OFF;
UPDATE [tblfacilityDivision] SET [FacilityID] = @FacilityID, [DepartmentName] = @DepartmentName, [ContactPhone1] = @ContactPhone1, [ContactPhone2] = @ContactPhone2, [ContactFirstName] = @ContactFirstName, [ContactLastName] = @ContactLastName, [ContactEmail] = @ContactEmail, [PINRequired] = @PINRequired, [DayTimeRestrict] = @DayTimeRestrict, [userName] = @userName, [ModifyDate] = getdate() WHERE (([DivisionID] = @DivisionID));
	


