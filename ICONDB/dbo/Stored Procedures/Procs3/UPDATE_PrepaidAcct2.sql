﻿
CREATE PROCEDURE [dbo].[UPDATE_PrepaidAcct2]
(
	@PhoneNo char(10),
	@FirstName varchar(25),
	@LastName varchar(25),
	@Address varchar(75),
	@City varchar(20),
	@State char(2),
	@ZipCode varchar(10),
	@Country varchar(20),
	@Email varchar(50),
	@Password varchar(20),
	@RelationshipID tinyint,
	@InmateName varchar(50)
)
AS
	SET NOCOUNT OFF;
UPDATE [tblPrepaid] SET [FirstName] = @FirstName, [LastName] = @LastName, [Address] = @Address, [City] = @City, [State] = @State, [ZipCode] = @ZipCode, [Country] = @Country, [RelationshipID] = @RelationshipID,[InmateName] = @InmateName 
	 WHERE (([PhoneNo] = @PhoneNo));

IF @Password <> ''
	BEGIN
		UPDATE [tblEndusers] SET [Email] = @Email, [Password] = @Password WHERE tblEndusers.EnduserID = (SELECT tblPrepaid.EndUserID FROM tblPrepaid WHERE [PhoneNo] = @PhoneNo );
		RETURN 0;
	END
ELSE
	BEGIN
		UPDATE [tblEndusers] SET [Email] = @Email WHERE tblEndusers.EnduserID = (SELECT tblPrepaid.EndUserID FROM tblPrepaid WHERE [PhoneNo] = @PhoneNo );
		RETURN 0;
	END

