
CREATE PROCEDURE [dbo].[SELECT_Inmate_Incident_Report]
( 
	@FacilityID int
)
AS


SELECT  [IncidentID]
      ,[ANI]
      ,R.InmateID
      ,R.PIN
      ,[ReportTime]
      ,[Channel]
      ,[FolderName]
      ,[FileName]
      ,[DBerror]
      ,[ServerIP]
      ,[ComputerName]
      ,R.InputDate
      ,isnull(R.IncidentType,1) as IncidentType
      ,X.descript as descript
      ,I.FirstName
      ,I.LastName
  FROM [leg_Icon].[dbo].[tblIncidentReport] R
  inner join [leg_Icon].[dbo].[tblInmate] I on R.InmateID = I.InmateID and R.PIN = I.PIN and R.FacilityID = I.FacilityID
  left join [leg_Icon].[dbo].[tblACPs] P on p.IpAddress = R.serverIP
  inner join [leg_Icon].[dbo].[tblIncidentType] X on R.IncidentID = X.IncidentType
  
  where R.FacilityID = @facilityID
 
 order by R.InputDate desc

  


