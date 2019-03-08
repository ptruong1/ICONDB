


CREATE PROCEDURE [dbo].[UPDATE_UserAccount]
(
	@FirstName varchar(20),
	@LastName varchar(25),
	@MidName varchar(15),
	@Department varchar(25),
	@Phone nchar(10),
	@Email varchar(50),
	@UserID varchar(20),
	@OldPassword varchar(20),
	@NewPassword varchar(20)
)
AS
	SET NOCOUNT OFF;
	Declare @EnCryptPass  varbinary(200);
	--EXEC [dbo].[LegEncrypt] @OldPassword,	@EnCryptPass  OUTPUT
	IF @OldPassword <> '' 
		IF (SELECT count(*) FROM tblUserprofiles WHERE UserID = @UserID and Password = @OldPassword) > 0
			IF @NewPassword <> ''
				BEGIN
					EXEC [dbo].[LegEncrypt] @NewPassword,	@EnCryptPass  OUTPUT
					UPDATE tblUserprofiles SET [FirstName] = @FirstName, [LastName] = @LastName, [MidName] = @MidName, [Department] = @Department, 
						[Phone] = @Phone, [Email] = @Email, Password =@NewPassword  WHERE UserID = @UserID;
						RETURN 0;
				END
			ELSE
				BEGIN
					UPDATE tblUserprofiles SET [FirstName] = @FirstName, [LastName] = @LastName, [MidName] = @MidName, [Department] = @Department, 
						[Phone] = @Phone, [Email] = @Email WHERE UserID = @UserID;
						RETURN 0;
				END
		ELSE
			RETURN -1; --Wrong password	
	ELSE
		UPDATE tblUserprofiles SET [FirstName] = @FirstName, [LastName] = @LastName, [MidName] = @MidName, [Department] = @Department, 
				[Phone] = @Phone, [Email] = @Email WHERE UserID = @UserID;
		RETURN 0;



