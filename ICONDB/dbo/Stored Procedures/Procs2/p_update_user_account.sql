


CREATE PROCEDURE [dbo].[p_update_user_account]
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
	IF @OldPassword <> '' 
		IF (SELECT count(*) FROM tblUserprofiles WHERE UserID = @UserID and Password = @OldPassword) > 0
			IF @NewPassword <> ''
				BEGIN
					--EXEC [dbo].[LegEncrypt] @NewPassword,	@EnCryptPass  OUTPUT
					UPDATE tblUserprofiles SET [FirstName] = @FirstName, [LastName] = @LastName, [MidName] = @MidName, [Department] = @Department, 
						[Phone] = @Phone, [Email] = @Email,[modifyDate]=GETDATE() ,Password=@NewPassword WHERE UserID = @UserID;
						RETURN 0;
				END
			ELSE
				BEGIN
					UPDATE tblUserprofiles SET [FirstName] = @FirstName, [LastName] = @LastName, [MidName] = @MidName, [Department] = @Department, 
						[Phone] = @Phone, [Email] = @Email, [modifyDate]=GETDATE() WHERE UserID = @UserID;
						RETURN 0;
				END
		ELSE
			RETURN -1; --Wrong password	
	ELSE
		UPDATE tblUserprofiles SET [FirstName] = @FirstName, [LastName] = @LastName, [MidName] = @MidName, [Department] = @Department, 
				[Phone] = @Phone, [Email] = @Email, [modifyDate]=GETDATE() WHERE UserID = @UserID;
		RETURN 0;



