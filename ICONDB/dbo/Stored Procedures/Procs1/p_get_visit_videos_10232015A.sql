﻿

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_videos_10232015A] 
@facilityID int,
@fromDate varchar(10),
@toDate	  varchar(25),
@InmateID varchar(12),
@InmateName varchar(50),
@VisitType int,
@VisitStatus int,
@AppointmentNo int,
@VisitorFName varchar(25),
@VisitorLName varchar(25)

AS
	Declare @ReturnCode   int 
	set @ReturnCode = 0 
	Declare @recordID int ,@flatform  tinyint
		
	SET NOCOUNT OFF;
	

 IF @AppointmentNo <> 0  --Level 1
 Begin
	  Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP
	  , A.StationID, L.LocationName
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B
  On A.facilityID = B.FacilityID and A.InmateID = B.InmateID and B.Status = 1
    left Join  [leg_Icon].[dbo].tblVisitors D
	    On  A.VisitorID = D.VisitorID
	Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C
	    On A.FacilityID = C.FacilityID 
	Left Join  [leg_Icon].[dbo].tblVisitStatus Y
	    On A.status = Y.StatusID
	    
			Where
			A.FacilityID = @facilityID
			and A.ApmDate between @fromDate and @todate
			and A.RoomID = @AppointmentNo			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
      End
      
      ----------------------------------------------------------------------------------
 ELSE
 If @InmateID <> '' -- Level 1
	Begin -- Level 2
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorFName <> '') and (@VisitorLName <> '') and (@InmateName <> '')
	
	  Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP
	  , A.StationID, L.LocationName
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B On A.facilityID = B.FacilityID and A.InmateID = B.InmateID and B.Status = 1
  left Join  [leg_Icon].[dbo].tblVisitors D On  A.VisitorID = D.VisitorID
  Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C On A.FacilityID = C.FacilityID 
  Left Join  [leg_Icon].[dbo].tblVisitStatus Y
	    On A.status = Y.StatusID
				
			Where
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus
			and A.InmateName = @InmateName		
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
  
  else -- Level 2
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorFName <> '') and  (@InmateName <> '')
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP
, A.StationID, L.LocationName
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B On A.facilityID = B.FacilityID and A.InmateID = B.InmateID and B.Status = 1
  left Join  [leg_Icon].[dbo].tblVisitors D On  A.VisitorID = D.VisitorID
  Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C
	    On A.FacilityID = C.FacilityID 
  Left Join  [leg_Icon].[dbo].tblVisitStatus Y
	    On A.status = Y.StatusID
				
			Where
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
				 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorLName <> '') and  (@InmateName <> '')
	Select RoomID as recordID, [ApmDate]   ,[ApmTime], A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP
, A.StationID, L.LocationName
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X 	on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B On A.facilityID = B.FacilityID and A.InmateID = B.InmateID and B.Status = 1
  left Join  [leg_Icon].[dbo].tblVisitors D On  A.VisitorID = D.VisitorID
  Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C On A.FacilityID = C.FacilityID 
  Left Join  [leg_Icon].[dbo].tblVisitStatus Y On A.status = Y.StatusID
				
			Where
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VLastName = @VisitorLName	
				 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
  If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorFName <> '') 
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP
, A.StationID, L.LocationName
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A 
  left join tblVisitLocation L on A.locationID = L.LocationID 
  Left Join [leg_Icon].[dbo].[tblVisitType] X on A.visitType = X.VisitTypeID
  left Join [leg_Icon].[dbo].[tblInmate] B On A.facilityID = B.FacilityID and A.InmateID = B.InmateID and B.Status = 1
  left Join  [leg_Icon].[dbo].tblVisitors D  On  A.VisitorID = D.VisitorID
  Left Join  [leg_Icon].[dbo].tblVisitPhoneServer C On A.FacilityID = C.FacilityID 
  Left Join  [leg_Icon].[dbo].tblVisitStatus Y On A.status = Y.StatusID
			Where
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
			and D.VFirstName = @VisitorFName	
				 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
		If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorLName <> '') 
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
				
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else -- Level 2
	
		If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@InmateName <> '') 
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
			and A.InmateName = @InmateName
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	
		If ( @VisitType <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '') and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	
		If ( @VisitType <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@VisitorFName <> '') and (@InmateName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@VisitorLName <> '')  and (@InmateName <> '')
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			--and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			--and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitType <> -1 ) and (@VisitorFName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				
			and D.VFirstName = @VisitorFName	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				
			and D.VLastName = @VisitorLName	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			--and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			--and D.VFirstName = @VisitorFName	
			--and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitStatus <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '') and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	
		If ( @VisitStatus <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
				
			and A.status = @VisitStatus
				
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@VisitorFName <> '') and (@InmateName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@VisitorLName <> '')  and (@InmateName <> '')
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			
			and D.VLastName = @VisitorLName			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitStatus <> -1 ) and (@VisitorFName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
				
			and D.VFirstName = @VisitorFName	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
				
			and D.VLastName = @VisitorLName	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
						 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	else  -- Level 2
	
	
		If ( @VisitType <> -1 ) 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
  else --  Level 2
	If ( @VisitStatus <> -1 ) -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus			 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	  Else -- End Level 2
	If ( @VisitorFName <> '')  and (@VisitorLName <> '') and (@InmateName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and A.InmateName = @InmateName
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitorFName <> '')  and (@VisitorLName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitorFName <> '')  and (@InmateName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VFirstName = @VisitorFName	
			and A.InmateName = @InmateName
			and A.ApmDate between @fromDate and @todate
								 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitorLName <> '')  and (@InmateName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and A.InmateName = @InmateName	
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @InmateName <> '' )  -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and A.InmateName = @InmateName
			and A.ApmDate between @fromDate and @todate
			
					 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitorFName <> '' )  -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VFirstName = @VisitorFName	
			and A.ApmDate between @fromDate and @todate
								 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	
	If ( @VisitorLName <> '' )  -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	 Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
				 
			and A.InmateID = @InmateID  and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
			
	End

 --------------------------------------------------------------------------
ELSE  
If @InmateID = '' -- Level 1
	Begin -- Level 2
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorFName <> '') and (@VisitorLName <> '') and (@InmateName <> '')
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus
			and A.InmateName = @InmateName		
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
  
  else -- Level 2
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorFName <> '') and  (@InmateName <> '')
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
				 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorLName <> '') and  (@InmateName <> '')
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VLastName = @VisitorLName	
				 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
  If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorFName <> '') Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
			and D.VFirstName = @VisitorFName	
				 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
		If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@VisitorLName <> '') 
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
				
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else -- Level 2
	
		If ( @VisitType <> -1 ) and (@VisitStatus <> -1) and (@InmateName <> '') 
	Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
			and A.InmateName = @InmateName
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitType <> -1 ) and (@VisitStatus <> -1) 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			and A.status = @VisitStatus	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	
		If ( @VisitType <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '') and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
  B.PIN  , ISNULL(VisitDuration,0) as duration , A.Relationship,
	   A.VisitType, X.Descript, InmateLogInID, VisitorLogInID, Note, isNull(AlertCellPhone,'') as AlertCellPhone,  
	  isNull(AlertCellCarrier,'') as AlertCellCarrier, Y.Descript as ApptStatus, D.Phone1, ISNULL(TotalCharge,0) as TotalCharge, A.RecordOpt, ISNULL(A.RecordStatus,0) as RecordStatus, C.ChatServerIP as ChatServerIP

	  
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] A
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	
		If ( @VisitType <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@VisitorFName <> '') and (@InmateName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@VisitorLName <> '')  and (@InmateName <> '')
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			--and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			--and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitType <> -1 ) and (@VisitorFName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				
			and D.VFirstName = @VisitorFName	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				
			and D.VLastName = @VisitorLName	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitType <> -1 ) and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
			--and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			--and D.VFirstName = @VisitorFName	
			--and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitStatus <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '') and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	
		If ( @VisitStatus <> -1 ) and (@VisitorFName <> '') and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
				
			and A.status = @VisitStatus
				
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@VisitorFName <> '') and (@InmateName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			and D.VFirstName = @VisitorFName	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@VisitorLName <> '')  and (@InmateName <> '')
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
			
			and D.VLastName = @VisitorLName			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitStatus <> -1 ) and (@VisitorFName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
				
			and D.VFirstName = @VisitorFName	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@VisitorLName <> '')  
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
				
			and D.VLastName = @VisitorLName	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	else  -- Level 2
	If ( @VisitStatus <> -1 ) and (@InmateName <> '') 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus
			and A.InmateName = @InmateName	
						 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	else  -- Level 2
	
	
		If ( @VisitType <> -1 ) 
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			and A.visitType = @VisitType	
				 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
  else --  Level 2
	If ( @VisitStatus <> -1 ) -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
			
			and A.status = @VisitStatus			 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	  Else -- End Level 2
	If ( @VisitorFName <> '')  and (@VisitorLName <> '') and (@InmateName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and A.InmateName = @InmateName
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitorFName <> '')  and (@VisitorLName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VFirstName = @VisitorFName	
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitorFName <> '')  and (@InmateName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VFirstName = @VisitorFName	
			and A.InmateName = @InmateName
			and A.ApmDate between @fromDate and @todate
								 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @VisitorLName <> '')  and (@InmateName <> '') -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and A.InmateName = @InmateName	
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	If ( @InmateName <> '' )  -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and A.InmateName = @InmateName
			and A.ApmDate between @fromDate and @todate
			
					 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	If ( @VisitorFName <> '' )  -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VFirstName = @VisitorFName	
			and A.ApmDate between @fromDate and @todate
								 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	Else
	
	If ( @VisitorLName <> '' )  -- Level 2
		Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID
			and D.VLastName = @VisitorLName
			and A.ApmDate between @fromDate and @todate
								 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
	
	Else
	  Select RoomID as recordID, [ApmDate]   ,LEFT(ApmTime,8) as ApmTime, A.LimitTime, A.VisitorID, D.Email, A.EndUserID, A.Status, A.InmateID, A.InmateName, D.[VLastName], D.[VFirstName],
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
			A.FacilityID = @facilityID and 
			A.ApmDate between @fromDate and @todate
				 
			 and B.status = 1 order by A.ApmDate desc, A.ApmTime Desc
			
	End

