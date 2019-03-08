

CREATE PROCEDURE [dbo].[INSERT_PAN2]
(
	@InmateID varchar(12),
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
SELECT @PANCount = DNILimit FROM tblInmate WHERE InmateID = @InmateID  and facilityID = @facilityID	 ;
IF @PANCount <= (SELECT COUNT(*) FROM tblPHones WHERE InmateID = @InmateID and facilityID = @facilityID)  --- # of phones over limit
	RETURN -2;
IF (SELECT count(phoneNo) FROM tblPhones WHERE InmateID = @InmateID and facilityID = @facilityID and phoneNo = @PAN ) >0  -- exist 
	RETURN -1 ;
ELSE
	BEGIN
		INSERT INTO [tblPhones] ([phoneNo], [InmateID], [PIN], [LastName], [FirstName], [Address], [City], [State], [RelationshipID], [AlertToPhone], [AlertToCell], [AlertToEmail], [ZipCode], FacilityID) 
			VALUES (@PAN, @InmateID, @PIN, @LastName, @FirstName, @Address, @City, @State, @RelationshipID, @AlertToPhone, @AlertToCell, @AlertToEmail, @ZipCode, @facilityID);
		
			
		RETURN @@error;
	END

