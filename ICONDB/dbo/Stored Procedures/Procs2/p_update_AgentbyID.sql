
CREATE PROCEDURE [dbo].[p_update_AgentbyID] 
(	
@FacilityID int ,
@Password  varchar(20),
@UserID varchar(20),
@LastName  varchar(20)  ,  
@FirstName   varchar(20),  
@MidName  varchar(15) ,  
@Department  varchar(25) , 
@Phone  char(10) , 
@Email  varchar(50),

@Admin  bit,
@PowerUser bit, 
@FinanceAuditor bit,
@Investigator bit, 
@DataEntry bit, 
@UserDefine bit,

@FacilityConfig  bit,
@UserControl bit, 
@PhoneConfig bit,
@CallControl bit, 
@DebitCard bit, 
@InmateProfile bit,
@Report bit, 
@CallMonitor bit, 
@Messaging Bit, 
@VideoVisit Bit, 
@ServiceRequest bit,

@Original_UserID varchar(20),
@status tinyint,
@IPAddress  varchar(16)
)
AS

SET NOCOUNT OFF;
Declare @EnCryptUser varbinary(200), @EnCryptPass varbinary(200)
IF @UserID in (SELECT UserID FROM [tblUserprofiles] WHERE UserID <> @Original_UserID)
	RETURN -1;
ELSE
	BEGIN
		UPDATE [tblAuthUsers]
			 SET Admin = @Admin, PowerUser = @PowerUser, [Finance-Auditor] = @FinanceAuditor, Investigator = @Investigator, DataEntry = @DataEntry, UserDefine = @UserDefine,
			 FacilityConfig = @FacilityConfig, UserControl = @UserControl, PhoneConfig =@PhoneConfig, CallControl = @CallControl, DebitCard =@DebitCard, InmateProfile = @InmateProfile,
			 Report =@Report, CallMonitor = @CallMonitor, Messaging = @Messaging, VideoVisit = @VideoVisit, ServiceRequest = @ServiceRequest
		WHERE tblAuthUsers.AuthID  = (SELECT authID FROM tblUserprofiles WHERE UserID = @Original_UserID); 
		if(@Password <>'***')
			EXEC [dbo].[LegEncrypt] @password,	@EnCryptPass  OUTPUT;
		--exec [dbo].[LegEncrypt] @UserID,	@EnCryptUser  OUTPUT
		
		
		UPDATE [tblUserprofiles] SET [UserID] = @UserID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, [Department] = @Department, [Phone] = @Phone, [Email] = @Email ,
                                          [Password] = '***' , [status] = @status, [IPaddress]=@IPaddress, UserIDDEC= @EnCryptUser, PasswordDEC = @EnCryptPass
		WHERE [UserID] = @Original_UserID; 

		--EXEC  INSERT_ActivityLogs1   @FacilityID,5, 0,	@Createby,@IPAddress,	@UserID
		
		RETURN 0;
	END
