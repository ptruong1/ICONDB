

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_videos_fromchart_byAgent] 
@AgentID int,
@fromDate varchar(10),
@fromhour int,
@isHour bit
AS
IF @isHour = 1 
Begin
Select A.facilityID, RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP
	  , A.StationID, L.LocationName
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X 
	on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B
  On A.facilityID = B.FacilityID and A.InmateID = B.InmateID and B.Status = 1
  left Join  [leg_Icon].[dbo].tblVisitors D
	    On  A.VisitorID = D.VisitorID
	Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C
	    On A.FacilityID = C.FacilityID 
	Left Join  [leg_Icon].[dbo].tblVisitStatus Y
	    On A.status = Y.StatusID
    				
			Where
			C.FacilityID in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID ) and 
			A.ApmDate = @fromdate and
			A.status = 5 AND
			LEFT(ApmTime, 2) = @fromhour
			order by A.ApmDate desc, A.ApmTime Desc
End
Else
Begin
Select A.facilityID, RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP
	  , A.StationID, L.LocationName
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X 
	on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B
  On A.facilityID = B.FacilityID and A.InmateID = B.InmateID  and B.Status = 1
  left Join  [leg_Icon].[dbo].tblVisitors D
	    On  A.VisitorID = D.VisitorID
	Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C
	    On A.FacilityID = C.FacilityID 
	Left Join  [leg_Icon].[dbo].tblVisitStatus Y
	    On A.status = Y.StatusID
				
			Where
			A.FacilityID in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID ) and 
			A.ApmDate = @fromDate and
			A.status = 5
			order by A.ApmDate desc, A.ApmTime Desc
End

