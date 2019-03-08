
CREATE PROCEDURE [dbo].[SELECT_Activity_Log]
( 
	@FacilityID int,
	@FromDate dateTime,
	@Todate DateTime 
)
AS
	SET NOCOUNT ON;

SELECT  [ActivityLogID]
      ,A.ActivityID
      ,A.ActTime
      ,A.RecordID
      ,A.FacilityID
      ,A.UserName
      ,A.UserIP
      ,A.Reference
      ,(CASE A.ActivityID When '2' Then 'Listen RecordID: ' + CAST( RecordID as varchar(12))  When '3' Then 'Download RecordID: ' + CAST( RecordID AS varchar(12))   Else  A.UserAction End) UserAction
      ,D.Descript as TypeActivity
  FROM [leg_Icon].[dbo].[tblActivityLog] A
  inner join [leg_Icon].[dbo].[tblActivity]  D on A.ActivityID = D.ActivityID
  where FacilityID = @FacilityID 
  and (ActTime between @fromDate and dateadd(d,1,@todate) )
  Order by ActTime Desc
  
