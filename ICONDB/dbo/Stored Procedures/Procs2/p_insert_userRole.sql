

Create PROCEDURE [dbo].[p_insert_userRole]
(@FacilityID int 
           ,@RoleID tinyint 
           ,@RoleDescript varchar(25) 
           ,@FacilityConfig bit 
           ,@UserControl bit 
           ,@PhoneConfig bit 
           ,@CallControl bit 
           ,@DebitCard bit 
           ,@InmateProfile bit 
           ,@Report bit 
           ,@CallMonitor bit 
           ,@Messaging bit 
           ,@VideoVisit bit 
           ,@ServiceRequest bit 
           ,@MyReport bit 
           ,@Form bit 
           ,@RoleAuthID int )
AS
	SET NOCOUNT OFF;
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
           ,@RoleID 
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
           ,@Form 
           ,@RoleAuthID )

