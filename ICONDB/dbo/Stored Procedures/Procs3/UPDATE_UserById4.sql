
CREATE PROCEDURE [dbo].[UPDATE_UserById4]
(	
	@FacilityID int,
	@Password varchar(20),
	@UserID varchar(20),
	@LastName  varchar(20),  
	@FirstName   varchar(20),  
	@MidName  varchar(15) ,
	@ID int,  
	@Department  varchar(25), 
	@Phone  char(10), 
	@Email  varchar(50),
	@admin  bit, 
	@monitor  bit,
	@finance  bit ,
	@dataEntry  bit,
	@Controler  bit,
	@Description  varchar(50),
	@Original_UserID varchar(20),
	@status tinyint,
	@IPaddress varchar(16)
             )
AS

SET NOCOUNT OFF;
Declare @EnCryptUser varbinary(200), @EnCryptPass varbinary(200)
IF @UserID in (SELECT UserID FROM [tblUserprofiles] WHERE UserID <> @Original_UserID)
	RETURN -1;
ELSE
	BEGIN
		UPDATE [tblAuth] SET admin = @admin, monitor = @monitor, finance = @finance, dataEntry = @dataEntry, Description = @Description, Controler = @Controler
		WHERE tblAuth.authID = (SELECT authID FROM tblUserprofiles WHERE UserID = @Original_UserID); 
		if(@Password <>'***')
			EXEC [dbo].[LegEncrypt] @password,	@EnCryptPass  OUTPUT;
		--exec [dbo].[LegEncrypt] @UserID,	@EnCryptUser  OUTPUT
		
		
		UPDATE [tblUserprofiles] SET [UserID] = @UserID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, [ID] = @ID, [Department]  = @Department, [Phone] = @Phone, [Email] = @Email ,
                                          [Password] = '***' , [status] = @status, [IPaddress]=@IPaddress, UserIDDEC= @EnCryptUser, PasswordDEC = @EnCryptPass
		WHERE [UserID] = @Original_UserID; 

		--EXEC  INSERT_ActivityLogs1   @FacilityID,5, 0,	@Createby,@IPAddress,	@UserID
		
		RETURN 0;
	END
