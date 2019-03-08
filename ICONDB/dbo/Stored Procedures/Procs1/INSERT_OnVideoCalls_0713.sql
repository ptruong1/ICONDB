-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[INSERT_OnVideoCalls_0713]
(
	
        @InmateID int,
        @VisitorFName varchar(25),
        @ScheduledDate smalldatetime,
        @IPAddress varchar(15)  
)
AS
	SET NOCOUNT OFF;

INSERT INTO  tblOnVideoCalls
 ( RecordID
 , Calldate
 , ConnectTime
 , FromNo 
 , ToNo
 , BillToNo 
 , MethodOfRecord
 , billType
 , callType
 , FromState
 , FromCity 
 , ToState
 , ToCity
 , CallPeriod
 , LibraryCode
 , CreditCardType
 , CreditCardNo 
 , CreditCardExp
 , CreditCardCvv
 ,	ProjectCode 
 , userName
 , errorCode
 , rateClass
 , firstMinute
 , nextMinute
 , connectFee
 , TotalSurcharge
 , MinDuration
 , recordDate
 , ratePlanID
 , DbError
 , ResponseCode
 , AgentID
 , RecordFile
 , MinIncrement
 , channel
 , folderDate
 , InmateID
 , PIN
 , facilityID
 , InRecordFile
 , lastModify
 , phoneType
 , duration	
 )
 SELECT [ID] as recordID
		, CONVERT(VARCHAR(6), [ScheduledDate], 12) as CallDate
		, REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114),':','') as connectTime
		,[BoothAssigned] as FromNo
		, '' as ToNo
		, '' as BillToNo 
		, '' as MethodOfRecord
		, [VisitBillType] as billType
		, [VisitType] as callType
		, '' as FromState
		, '' as FromCity 
		, '' as ToState
		, '' as ToCity
		, '' as CallPeriod
		, '' as LibraryCode
		, '' as CreditCardType
		, '' as CreditCardNo 
		, '' as CreditCardExp
		, '' as CreditCardCvv
		, '' as ProjectCode 
		, IPAddress as userName
		,  0 as  errorCode
		,  6 as rateClass
		,  0 as firstMinute
		,  0 as nextMinute
		,  0 as connectFee
		,  0 as totalSurcharge
		,  0 as  MinDuration
		,  [ScheduledDate] as recordDate
		,  '' as ratePlanID
		,  Null DbError
		, '' as ResponseCode
		, 0 as AgentID
		, '' RecordFile
		, 1 as MinIncrement
		, '' as channel
		, CONVERT(VARCHAR(8), [ScheduledDate], 112) as folderDate
		,[InmateID] as InmateID
		,[PIN] as PIN
		,tblAVConferenceSchedule.facilityid as facilityID
		, '' as InRecordFile
		,[modifydate] as  lastModify
		, '' as phoneType
		, 0 as duration	
        
        
		     
      
  FROM [tblAVConferenceSchedule], tblAVChatWebsite
	Where	tblAVConferenceSchedule.facilityid = tblAVChatWebsite.facilityid and
			(InmateID = @InmateID Or VisitorFName = @VisitorFName) and
			(ScheduledDate between @ScheduledDate and dateadd(d,1,@ScheduledDate) ) and
			tblAVChatWebsite.IPAddress = @IPAddress

