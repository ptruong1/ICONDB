

CREATE PROCEDURE [dbo].[INSERT_PAN1]
(
	@PAN varchar(15),
	@PIN varchar(12),
	@LastName varchar(25),
	@FirstName varchar(25),
	@Address varchar(50),
	@City varchar(20),
	@State char(2),
	@RelationshipID tinyint,
	@AlertToPhone char(10),
	@AlertToCell varchar(25),
	@AlertToEmail varchar(25),
	@ZipCode varchar(10),
	@facilityID	int

)
AS
	SET NOCOUNT OFF;
	DECLARE @PANCount int;
SELECT @PANCount = DNILimit FROM tblInmate WHERE PIN = @PIN  and facilityID = @facilityID	 ;
IF @PANCount <= (SELECT COUNT(*) FROM tblPHones WHERE PIN = @PIN and facilityID = @facilityID)
	RETURN -2;
IF @PAN in (SELECT phoneNo FROM tblPhones WHERE PIN = @PIN and facilityID = @facilityID)
	RETURN -1 ;
ELSE
	BEGIN
		INSERT INTO [tblPhones] ([phoneNo], [PIN], [LastName], [FirstName], [Address], [City], [State], [RelationshipID], [AlertToPhone], [AlertToCell], [AlertToEmail], [ZipCode], FacilityID) 
			VALUES (@PAN, @PIN, @LastName, @FirstName, @Address, @City, @State, @RelationshipID, @AlertToPhone, @AlertToCell, @AlertToEmail, @ZipCode, @facilityID);
		RETURN 0;
	END

