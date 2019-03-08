

CREATE PROCEDURE [dbo].[p_Report_Prepaid_accounts_Email]
@FacilityID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 
 AS


(SELECT O.FacilityID
		,F.Location
		,'' as UserName
		,'' as FirstName
	  ,'' as LastName
      ,'Service Available' as Email
		,'1' as PhoneOpt
      ,isnull(VoiceMessageOpt,0) as VoiceMessageOpt
      ,isnull(EmailOpt,0) as EmailOpt
      ,isnull(VideoMessageOpt,0) as VideoMessageOpt
      ,isnull(VideoVisitOpt,0) as VideoVisitOpt
      ,1 as sortKey
  FROM [leg_Icon].[dbo].[tblFacilityOption] O, [leg_Icon].[dbo].[tblFacility] F
  where O.facilityID = F.FacilityID
  and O.facilityID = @FacilityID

  union
SELECT P.FacilityID
	  ,F.Location
      ,E.UserName
	  ,P.FirstName
	  ,P.LastName
      ,[Email]
      
	  ,case when (SELECT Count(RecordID)  from tblCallsBilled C where E.UserName = C.toNo)  >0 then 
	  (SELECT Count(RecordID)  from tblCallsBilled C where E.UserName = C.toNo) 
		else 0 end as PhoneOpt
	 
	  ,case when (SELECT Count(MessengerNo) from tblMailboxDetail M where E.UserName = M.MessengerNo and MessageTypeID = 1)  >0 then 
	  (SELECT Count(MessengerNo) from tblMailboxDetail M where E.UserName = M.MessengerNo and MessageTypeID = 1) 
		else 0 end as voiceMessageOpt
	  ,case when (SELECT Count(MessengerNo)  from tblMailboxDetail M where E.UserName = M.MessengerNo and MessageTypeID = 2)  >0 then 
	   (SELECT Count(MessengerNo)  from tblMailboxDetail M where E.UserName = M.MessengerNo and MessageTypeID = 2)
		else 0 end as EmailOpt
	  ,case when (SELECT Count(MessengerNo)  from tblMailboxDetail M where E.UserName = M.MessengerNo and MessageTypeID = 4)  >0 then 
	  (SELECT Count(MessengerNo)  from tblMailboxDetail M where E.UserName = M.MessengerNo and MessageTypeID = 4) 
		else 0 end as VideoMessageOpt
	,case when (SELECT Count(EndUserID)  from tblVisitEnduserSchedule V where E.UserName = V.EndUserID)  >0 then 
	(SELECT Count(EndUserID)  from tblVisitEnduserSchedule V where E.UserName = V.EndUserID)
		else 0 end as VideoMessageOpt

	  ,2 as sortKey

  FROM [leg_Icon].[dbo].[tblEndusers] E
  left join [leg_Icon].[dbo].[tblPrepaid] P on E.userName = P.PhoneNo 
  left join [leg_Icon].[dbo].[tblFacility] F on F.facilityID = P.FacilityID

  where P.facilityID = @FacilityID 
  and (P.inputDate between @fromDate and dateadd(d,1,@todate) )
  and E.Email not in ('no@email.com', 'no@no.com', 'na@na.com','no@golegacy.com')) 

  order by Location, sortKey
