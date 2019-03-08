
CREATE PROCEDURE [dbo].[UPDATE_PrepaidAcct3]
(
	@PhoneNo char(12),
	@FirstName varchar(25),
	@LastName varchar(25),
	@Address varchar(75),
	@City varchar(20),
	@CountryID smallint,
	@CountryCode varchar(3),
	@StateID smallint,
	@ZipCode varchar(10),
	@Email varchar(50),
	@Password varchar(20)
)
AS
	SET NOCOUNT OFF;
UPDATE [tblPrepaid] SET [FirstName] = @FirstName, [LastName] = @LastName, [Address] = @Address, [City] = @City, [StateID] = @StateID, [ZipCode] = @ZipCode, [CountryCode] = @CountryCode, [CountryID] = @CountryID
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

