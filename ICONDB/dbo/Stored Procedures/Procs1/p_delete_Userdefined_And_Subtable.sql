


CREATE PROCEDURE [dbo].[p_delete_Userdefined_And_Subtable]
(
	@AuthId int,
	@facilityID int,
	@userName varchar(30),
	@UserIP varchar(25)
)
AS
SET NOCOUNT OFF;
DECLARE  @count int;
Declare  @return_value int, @UserAction varchar(200) ;
SET @count = 0;
SELECT @count = COUNT(*) FROM [tblUserprofiles] WHERE authID = @AuthId AND FacilityID = @facilityID;
IF @count > 0
	RETURN -1;
ELSE
BEGIN
	DELETE FROM [dbo].[tblAuthUsers] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthFacilityTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthUserTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthPhoneTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthCallControlTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthDebitTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthInmateTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthReportTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthMonitorTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthMessageTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthVideoVisitTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthServiceRequestTab] WHERE AuthID = @AuthId 
	DELETE FROM [dbo].[tblAuthFormTab] WHERE AuthID = @AuthId 

	
 	Set @UserAction = 'Delete User Role ' + '" ' +cast(@AuthID as varchar(8)) + ' "'
	EXEC  INSERT_ActivityLogs5   @authID,5, @UserAction, @userName, @UserIP
	RETURN 0;
END
