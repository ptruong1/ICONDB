


CREATE PROCEDURE [dbo].[INSERT_LocationByDivisionID]
(
	@DivisionID int,
	@Descript varchar(50),
	@DayTimeRestrict bit,
	@PINrequired bit,
	@UserName varchar(25)
)
AS
SET NOCOUNT OFF;
	Declare  @return_value int, @nextID int, @ID int, @tblFacilityLocation nvarchar(32) ;
 EXEC   @return_value = p_create_nextID 'tblFacilityLocation', @nextID   OUTPUT
    set           @ID = @nextID ;    
INSERT INTO [tblFacilityLocation] ([LocationID] ,[DivisionID], [Descript], [DayTimeRestrict], [PINrequired], [UserName], [ModifyDate])
  VALUES (@ID, @DivisionID, @Descript, @DayTimeRestrict, @PINrequired, @UserName, getdate());

--INSERT INTO [tblFacilityLocation] ([DivisionID], [Descript], [DayTimeRestrict], [PINrequired], [UserName], [ModifyDate]) VALUES (@DivisionID, @Descript, @DayTimeRestrict, @PINrequired, @UserName, getdate());

--	SET NOCOUNT OFF;
--INSERT INTO [tblFacilityLocation] ([DivisionID], [Descript], [DayTimeRestrict], [PINrequired], [UserName], [ModifyDate]) VALUES (@DivisionID, @Descript, @DayTimeRestrict, @PINrequired, @UserName, getdate());



