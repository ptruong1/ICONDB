



CREATE PROCEDURE [dbo].[INSERT_DivisionByFacilityID]
(
	@DivisionID int OUTPUT,
	@FacilityID int,
	@DepartmentName varchar(50),
	@ContactPhone1 char(10),
	@ContactPhone2 char(10),
	@ContactFirstName varchar(20),
	@ContactLastName varchar(50),
	@ContactEmail varchar(25),
	@PINRequired bit,
	@DayTimeRestrict bit,
	@userName varchar(25)
)
AS

SET NOCOUNT OFF;
	 Declare  @return_value int, @nextID int, @ID int, @tblfacilityDivision nvarchar(32) ;

       EXEC   @return_value = p_create_nextID 'tblfacilityDivision', @nextID   OUTPUT
       set           @ID = @nextID ;    
INSERT INTO [tblfacilityDivision] ([DivisionID] ,[FacilityID], [DepartmentName], [ContactPhone1], [ContactPhone2], [ContactFirstName], [ContactLastName],
			 [ContactEmail], [PINRequired], [DayTimeRestrict], [userName], [ModifyDate])
			VALUES (@ID, @FacilityID, @DepartmentName, @ContactPhone1, @ContactPhone2, @ContactFirstName, @ContactLastName, @ContactEmail, @PINRequired, @DayTimeRestrict, @userName, getdate());
SET @DivisionID = @ID;
return 0;

--	SET NOCOUNT OFF;
--INSERT INTO [tblfacilityDivision] ([FacilityID], [DepartmentName], [ContactPhone1], [ContactPhone2], [ContactFirstName], [ContactLastName], [ContactEmail], [PINRequired], [DayTimeRestrict], [userName], [ModifyDate]) VALUES (@FacilityID, @DepartmentName, @ContactPhone1, @ContactPhone2, @ContactFirstName, @ContactLastName, @ContactEmail, @PINRequired, @DayTimeRestrict, @userName, getdate());
--SET @DivisionID = SCOPE_IDENTITY();
--return 0;



