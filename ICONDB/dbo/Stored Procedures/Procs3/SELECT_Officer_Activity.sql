
CREATE PROCEDURE [dbo].[SELECT_Officer_Activity]
( 
	@FacilityID int
)
AS


SELECT  [UserID]
       ,U.FacilityID
       ,[LastName]
      ,[FirstName]
      ,[MidName]
      ,U.ID
      ,[ANI]
      ,[BadgeID]
      ,[RecordDate]
      ,isnull(RecordName,'') as RecordName
      ,isnull(CheckInStatus,0) as CheckInStatus
      ,isnull(P.ComputerName,'') as ComputerName
      ,isnull(A.ServerIP,'') as ServerIP

 --FROM [leg_Icon].[dbo].[tblUserprofiles] U
 --left join [leg_Icon].[dbo].[tblOfficerCheckIn] A on A.BadgeID = U.ID and datediff(HH,A.recordDate,GETDATE()) < 48
 --left join [leg_Icon].[dbo].[tblACPs] P on p.IpAddress = A.serverIP 
 --where U.FacilityID = @facilityID

 FROM [leg_Icon].[dbo].[tblUserprofiles] U
 left join [leg_Icon].[dbo].[tblOfficerCheckIn] A on A.BadgeID = U.ID and 
 U.FacilityID = A.FacilityID and
 datediff(HH,A.recordDate,GETDATE()) < 48
 left join [leg_Icon].[dbo].[tblACPs] P on p.IpAddress = A.serverIP 
 where A.FacilityID = @facilityID
 
 order by UserID

  

  --select * from [tblActivity] where userName = 'rquinto' 

