

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_videos_for_Approval] 
@facilityID int

AS
	--Declare @ReturnCode   int 
	--set @ReturnCode = 0 
	--Declare @recordID int ,@flatform  tinyint
		
SET NOCOUNT OFF;

Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, isnull(D.Email,'') as Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, 
       isnull(D.VLastName,'') as VLastName, isnull(D.VFirstName,'') as VFirstName,
       (Select top 1 PIN from tblInmate B where A.FacilityID = B.FacilityId and A.InmateID = B.InmateID order by ModifyDate desc) as PIN  , 
       ISNULL(VisitDuration,0) as duration , A.Relationship,A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	   isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, 
	   ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP,A.StationID, L.LocationName, L.LocationID, D.VisitorID, isnull(D.VImage,' ') as VImage, 
	   A.CreatedBy, A.ApprovedBy, A.CreatedBy, A.ApprovedBy 

FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X on A.visitType = X.VisitTypeID
  left Join  [leg_Icon].[dbo].tblVisitors D On  A.VisitorID = D.VisitorID
  Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C On A.FacilityID = C.FacilityID 
  Left Join  [leg_Icon].[dbo].tblVisitStatus Y On A.status = Y.StatusID
    
Where
	A.FacilityID = @facilityID and status =1
order by A.ApmDate desc, A.ApmTime Desc
   
