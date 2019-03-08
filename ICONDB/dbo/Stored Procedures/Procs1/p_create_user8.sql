
CREATE PROCEDURE [dbo].[p_create_user8]
@UserID varchar(20),  
@Password  varchar(20),
@FacilityID int ,
@AgentID  int,
@LastName  varchar(20)  ,  
@FirstName   varchar(20), 
@ID int, 
@MidName  varchar(15) ,  
@Department  varchar(25) , 
@Phone  char(10) , 
@Email  varchar(50),
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
@MyReport bit,
@Createby	varchar(20),
@IPAddress  varchar(16),
@Admin bit,
@PowerUser bit,
@Finance_Auditor bit,
@Investigator bit,
@DataEntry bit,
@UserDefine bit,
@UserIP varchar(25),
@authID int OUTPUT
 AS
Declare  @userLevel smallint, @EnCryptUser varbinary(1000), @EnCryptPass varbinary(1000)
Declare  @UserAction varchar(100),@ActTime datetime;
 Declare  @return_value int, @nextID int, @CurrentID int, @tblAuthUsers nvarchar(32) ;

       EXEC   @return_value = p_create_nextID 'tblAuthUsers', @nextID   OUTPUT
       set           @CurrentID = @nextID ;     
insert tblAuthUsers(AuthID, FacilityConfig, UserControl, PhoneConfig, CallControl ,DebitCard ,InmateProfile ,Report, CallMonitor ,Messaging, VideoVisit, ServiceRequest,MyReport,[Admin],PowerUser,[Finance-Auditor],Investigator,DataEntry,UserDefine)
		   values(@CurrentID, @FacilityConfig, @UserControl, @PhoneConfig, @CallControl ,@DebitCard ,@InmateProfile ,@Report, @CallMonitor ,@Messaging,@VideoVisit, @ServiceRequest,@MyReport,@Admin,@PowerUser,@Finance_Auditor,@Investigator,@DataEntry,@UserDefine);

--insert tblAuthUsers( FacilityConfig, UserControl, PhoneConfig, CallControl ,DebitCard ,InmateProfile ,Report, CallMonitor ,Messaging, VideoVisit, ServiceRequest,MyReport,[Admin],PowerUser,[Finance-Auditor],Investigator,DataEntry,UserDefine)
		   --values(@FacilityConfig, @UserControl, @PhoneConfig, @CallControl ,@DebitCard ,@InmateProfile ,@Report, @CallMonitor ,@Messaging,@VideoVisit, @ServiceRequest,@MyReport,@Admin,@PowerUser,@Finance_Auditor,@Investigator,@DataEntry,@UserDefine);

SET @FacilityID = isnull(@FacilityID,0);
SET  @AgentID = isnull(@AgentID,0);
SET @authID = @CurrentID;
If(@AgentID =0  and  @FacilityID =0)  
	set  @userLevel  =1;
Else if(@FacilityID >0)  
	set  @userLevel  =3;
Else If(@AgentID >= 1 and  @FacilityID =0) 
	 set  @userLevel  =2;
--exec [dbo].[LegEncrypt] @UserID,	@EnCryptUser  OUTPUT;
--EXEC [dbo].[LegEncrypt] @password,	@EnCryptPass  OUTPUT;

Insert tblUserprofiles (UserID , Password, FacilityID , AgentID, LastName ,  FirstName ,  MidName ,ID,  Department , authID, Phone , Email, userLevel, Createdby, IPaddress) 
values(@UserID,@password  , @FacilityID , @AgentID , @LastName  ,@FirstName   ,@MidName  , @ID, @Department  , @authID, @Phone  ,@Email,  @userLevel ,@Createby,@IPaddress);
--EXEC  INSERT_ActivityLogs1   @FacilityID,5, 0,	@Createby,@IPAddress,	@UserID;
 SET  @UserAction =  'Add User: ' + @UserID;
 EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

EXEC  INSERT_ActivityLogs3	@FacilityID ,5 ,@ActTime, 0,@Createby ,@UserIP,@UserID,@UserAction ;

