
CREATE PROCEDURE [dbo].[SELECT_Current_Activity]
( 
	@FacilityID int
)
AS


SELECT 
      A.UserName
      ,A.ActTime
      ,D.Descript as TypeActivity
      ,A.UserAction
      ,(CASE A.ActivityID When '2' Then A.RecordID  When '3' Then A.RecordID  Else  A.Reference End) Reference
  FROM [leg_Icon].[dbo].[tblActivityLog] A
  inner join [leg_Icon].[dbo].[tblActivity]  D on A.ActivityID = D.ActivityID
  where FacilityID = @FacilityID and datediff(HH,A.ActTime,GETDATE()) < 14 and A.ActivityID <20
  and A.UserName in (select  L.userName from [leg_Icon].[dbo].tblUserLogs L where (L.logoutTime is null and datediff(HH,L.LoginTime,GETDATE()) < 14))
  and A.recordID <> ''
  order by A.ActivityLogID,A.UserName DESC

  

  --select * from [tblActivity] where userName = 'rquinto' 

