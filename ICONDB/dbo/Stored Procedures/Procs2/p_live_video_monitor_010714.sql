-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_live_video_monitor_010714]
@facilityID	int
AS
	Declare @ReturnCode   int 
	set @ReturnCode = 0 
	Declare @recordID int ,@flatform  tinyint
		
	SET NOCOUNT OFF;
	

Select RoomID as recordID, [ApmDate]   , LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, 
	  ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, 
	  C.ChatServerIP as ChatServerIP, A.StationID, L.LocationName
	  
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B
  On A.facilityID = B.FacilityID and A.InmateID = B.InmateID
    left Join  [leg_Icon].[dbo].tblVisitors D
	    On  A.VisitorID = D.VisitorID
	Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C
	    On A.FacilityID = C.FacilityID 
	Left Join  [leg_Icon].[dbo].tblVisitStatus Y
	    On A.status = Y.StatusID
	    
			Where
			A.FacilityID = @facilityID
			and A.Status = 3			 
			order by A.ApmDate desc, A.ApmTime Desc
	
 
