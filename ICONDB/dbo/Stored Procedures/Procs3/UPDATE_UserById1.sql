

CREATE PROCEDURE [dbo].[UPDATE_UserById1]
(	
	@FacilityID int,
	@Password varchar(20),
	@UserID varchar(20),
	@LastName  varchar(20),  
	@FirstName   varchar(20),  
	@MidName  varchar(15) ,  
	@Department  varchar(25), 
	@Phone  char(10), 
	@Email  varchar(50),
	@admin  bit, 
	@monitor  bit,
	@finance  bit ,
	@dataEntry  bit,
	@Description  varchar(50),
	@Original_UserID varchar(20),
	@status tinyint
             )
AS

SET NOCOUNT OFF;
DECLARE @EnCryptUser varbinary(200),@EnCryptPass   varbinary(200)
IF @UserID in (SELECT UserID FROM [tblUserprofiles] WHERE UserID <> @Original_UserID)
	RETURN -1;
ELSE
	BEGIN
		if(@Password <> '***')
			EXEC [dbo].[LegEncrypt] @password,	@EnCryptPass  OUTPUT ;
		--exec [dbo].[LegEncrypt] @UserID,	@EnCryptUser  OUTPUT;
		
		UPDATE [tblAuth] SET admin = @admin, monitor = @monitor, finance = @finance, dataEntry = @dataEntry, Description = @Description
		WHERE tblAuth.authID = (SELECT authID FROM tblUserprofiles WHERE UserID = @Original_UserID); 
		
		UPDATE [tblUserprofiles] SET [UserID] = @UserID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, [Department] = @Department, [Phone] = @Phone, [Email] = @Email ,
                                          [Password] = @Password , [status] = @status, UserIDDEC = @EnCryptUser, PasswordDEC = @EnCryptPass
		WHERE [UserID] = @Original_UserID; 
		
		RETURN 0;
	END

