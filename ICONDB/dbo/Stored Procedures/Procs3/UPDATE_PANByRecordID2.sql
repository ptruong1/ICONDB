



CREATE PROCEDURE [dbo].[UPDATE_PANByRecordID2]
(	
	@RecordID bigint,
	@InmateID varchar(12),
	@OrigInmateID varchar(12),
	@PIN varchar(12),
	@PAN char(15),
	@LastName varchar(25),
	@FirstName varchar(25),
	@Address varchar(50),
	@City varchar(20),
	@State char(2),
	@ZipCode varchar(10),
	@RelationshipID tinyint,
	@AlertToPhone char(10),
	@AlertToCell varchar(25),
	@AlertToEmail varchar(25)
)
AS
	SET NOCOUNT OFF;
IF @PAN in (SELECT phoneNo FROM tblPhones WHERE InmateID = @OrigInmateID AND RecordID <> @RecordID)
	BEGIN
		RETURN -1 ;
	END
ELSE
	BEGIN
		UPDATE [tblPhones]
			 SET [phoneNo] = @PAN,
			 [InmateID] = @InmateID,
			 [LastName] = @LastName,
			 [FirstName] = @FirstName,
			 [Address] = @Address, 
			[City] = @City,
			 [State] = @State,
			 [RelationshipID] = @RelationshipID, 
			[AlertToPhone] = @AlertToPhone,
			 [AlertToCell] = @AlertToCell,
			 [AlertToEmail] = @AlertToEmail,
			 [ZipCode] = @ZipCode,
			modifyDate = getdate()
			 WHERE RecordID = @RecordID;
		RETURN 0;
	END
