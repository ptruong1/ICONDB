
Create PROCEDURE [dbo].[p_reassign_user_defined_role]
@UserID varchar(30),
@RoleDescript varchar(50),
@FacilityID int ,
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
@Kites bit,
@MyReport bit,
@Createby	varchar(20),
@UserIP varchar(25),
--@SecondFactor bit,
@authID int OUTPUT
 AS
Declare  @userLevel smallint, @EnCryptUser varbinary(1000), @EnCryptPass varbinary(1000)
Declare  @UserAction varchar(100),@ActTime datetime;
 Declare  @return_value int, @nextID int, @CurrentID int, @tblAuthUsers nvarchar(32) ;

If (select count(*) from tblUserRole where RoleDescript = @RoleDescript and facilityId = @facilityId) > 0
begin 
 Set @AuthId = -1
end
else
begin
       EXEC   @return_value = p_create_nextID 'tblAuthUsers', @nextID   OUTPUT
       set           @CurrentID = @nextID ;     
insert tblAuthUsers(AuthID, FacilityConfig, UserControl, PhoneConfig, CallControl ,DebitCard ,InmateProfile ,Report, CallMonitor ,Messaging, VideoVisit, ServiceRequest,Kites ,MyReport,[Admin],PowerUser,[Finance-Auditor],Investigator,DataEntry,UserDefine)
		   values(@CurrentID, @FacilityConfig, @UserControl, @PhoneConfig, @CallControl ,@DebitCard ,@InmateProfile ,@Report, @CallMonitor ,@Messaging,@VideoVisit, @ServiceRequest,@Kites, @MyReport,0 , 0, 0, 0, 0, 0);

INSERT INTO [dbo].[tblUserRole]
           ([FacilityID]
           ,[RoleID]
           ,[RoleDescript]
           ,[FacilityConfig]
           ,[UserControl]
           ,[PhoneConfig]
           ,[CallControl]
           ,[DebitCard]
           ,[InmateProfile]
           ,[Report]
           ,[CallMonitor]
           ,[Messaging]
           ,[VideoVisit]
           ,[ServiceRequest]
           ,[MyReport]
		   ,[Form]
           ,[RoleAuthID])
     VALUES
           (@FacilityID
           ,(SELECT MAX(roleId) FROM tblUserRole WHERE facilityId = @facilityId) + 1 
           ,@RoleDescript
           ,@FacilityConfig 
           ,@UserControl
           ,@PhoneConfig
           ,@CallControl
           ,@DebitCard 
           ,@InmateProfile 
           ,@Report 
           ,@CallMonitor 
           ,@Messaging 
           ,@VideoVisit 
           ,@ServiceRequest 
           ,@MyReport 
		   ,@Kites 
           ,@CurrentID )

 SET  @UserAction =  'Add User Template: ' + @userId;
 EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

EXEC  INSERT_ActivityLogs3	@FacilityID ,5 ,@ActTime, 0,@Createby ,@UserIP ,@UserID,@UserAction ;

set @AuthId = @CurrentID

end