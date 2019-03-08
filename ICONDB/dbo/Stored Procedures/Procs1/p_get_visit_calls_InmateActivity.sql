-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_calls_InmateActivity] 
@facilityID int,
@RecordID varchar(50)

AS
BEGIN
  
	  SELECT P.StationID , PIN  ,   dateadd(s,-duration,RecordDate) as StartTime,  duration ,  RecordName as FileName ,    
	  (ComputerName + '\' + CAST(C.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName + '.WAV') as RecordName 
	  FROM [leg_Icon].[dbo].[tblVisitCalls] C, [leg_Icon].[dbo].tblACPs A, [leg_Icon].[dbo].tblVisitPhone P
	  where C.FacilityID = @facilityID and
			C.recordname = @RecordID And 
			C.ServerIP = A.IpAddress  
			
END

