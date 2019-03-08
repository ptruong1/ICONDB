

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Visitor_visit_history_1107] 
@facilityID int,
@InmateID varchar(12),
@VisitorID int

AS

 
 Begin
	  Select RoomID as recordID, [ApmDate]   ,[ApmTime], A.LimitTime, A.VisitorID, D.Email, A.EndUserID, 
	  Y.StatusID, Y.Descript as Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
 P.StationID, PIN  ,    dateadd(s,-duration,RecordDate) as StartTime ,  duration ,  RecordName as RecordID ,
	  ( CAST(A.facilityID as varchar(12)) + '\'+ FolderDate  + '\' + RecordName ) as RecordName,  
	  X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, RecordStatus, D.RecordOpt
	  
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  Left Join [leg_Icon].[dbo].[tblVisitType] X on A.visitType = X.VisitTypeID
  Left Join   [leg_Icon].[dbo].tblVisitPhone P
	    On A.FacilityID = P.FacilityID and
			A.StationID = P.StationID
    left Join [leg_Icon].[dbo].[tblVisitCalls] B
  On A.facilityID = B.FacilityID
  and A.RoomID = B.recordName and isnumeric(B.recordName) = 1
  left Join  [leg_Icon].[dbo].tblVisitors D
	    On  A.VisitorID = D.VisitorID
	Left Join  [leg_Icon].[dbo].tblACPs C
	    On B.ServerIP = C.ComputerName 
	Left Join  [leg_Icon].[dbo].tblVisitStatus Y
	    On A.status = Y.StatusID
			Where
			A.FacilityID = @facilityID and
			A.InmateID = @InmateID	and
			A.VisitorID = @VisitorID		 
			order by A.ApmDate Desc
      End
      
      ----------------------------------------------------------------------------------
 
