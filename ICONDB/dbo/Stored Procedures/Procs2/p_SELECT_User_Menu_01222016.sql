
CREATE PROCEDURE [dbo].[p_SELECT_User_Menu_01222016]
( 
	@AuthID int
)
AS
SELECT  
	tblAuthUsers.[AuthID]
	,tblAuthUsers.FacilityConfig "Facility"
      ,tblAuthUsers.[UserControl] "Users"
      ,tblAuthUsers.[PhoneConfig] "Phone Setup"
      ,tblAuthUsers.[CallControl] "Call Control"
      ,tblAuthUsers.[DebitCard] "Debit"
      ,tblAuthUsers.[InmateProfile] "Inmate"
      ,tblAuthUsers.[Report] "Report"
      ,tblAuthUsers.[CallMonitor] "Call Monitoring"
      ,tblAuthUsers.[Messaging] "Messaging"
      ,tblAuthUsers.[VideoVisit] "Video"
      ,tblAuthUsers.[ServiceRequest] "Service Request"
      ,tblAuthUsers.[Admin] "Admin"
      ,tblAuthUsers.[PowerUser] "PowerUser"
      ,tblAuthUsers.[Finance-Auditor] "Finance-Auditor"
      ,tblAuthUsers.[Investigator] "Investigator"
      ,tblAuthUsers.[DataEntry] "DataEntry"
      ,tblAuthUsers.[UserDefine] "UserDefine"
	  ,isnull(tblAuthFacilityTab.Layout, 1) as Layout
      ,isnull(tblAuthFacilityTab.Config, 1) as Configure
      ,isnull(tblAuthFacilityTab.Schedule, 1) Schedules
	  ,isnull(tblAuthUserTab.[CreateUser], 1) "New User"
      ,isnull(tblAuthUserTab.[ListUser], 1) "User List"
      ,isnull(tblAuthUserTab.[SearchUser], 1) "User Search"
      ,isnull(tblAuthUserTab.[ActivityUser], 1) "Activity Logs"
      ,isnull(tblAuthUserTab.[OfficerActivity], 1) "Officer Activity Logs"
	  ,isnull(tblAuthUserTab.[OfficerActivity], 1) "User Activities"
      ,isnull(tblAuthPhoneTab.[ListPhone], 1) "Phone List"
      ,isnull(tblAuthPhoneTab.[SearchPhone], 1) "Search Phone"
      ,isnull(tblAuthCallControlTab.[RestrictedNo], 1) "Restricted Numbers"
      ,isnull(tblAuthCallControlTab.[NonRecordNo], 1) "Non-Recordable Numbers"
      ,isnull(tblAuthCallControlTab.[FreeNo], 1) "Free Calls"
      ,isnull(tblAuthDebitTab.[ListDebit], 1) "Debit Account List"
      ,isnull(tblAuthDebitTab.[SearchDebit], 1)  "Search Debit Acct"
      ,isnull(tblAuthDebitTab.[TransferFund], 1) "Fund Transfer"
      ,isnull(tblAuthInmateTab.[RegisterInmate], 1) "Register"
      ,isnull(tblAuthInmateTab.[ListInmate], 1) "Inmate List"
      ,isnull(tblAuthInmateTab.[SearchInmate], 1) "Search Inmate"
      ,isnull(tblAuthInmateTab.[InmateSuspended], 1) "Inmate Suspended"
	  ,isnull(tblAuthInmateTab.[InmateActivity], 1) "Inmate Activities"
      ,isnull(tblAuthReportTab.[Report], 1) "Reports"
      ,isnull(tblAuthReportTab.[CDR], 1) "Report Call Detail"
	  ,isnull(tblAuthReportTab.[CustomReports], 1) "Custom Reports"
      ,isnull(tblAuthMonitorTab.[LiveMonitor], 1) "Live Monitor"
      ,isnull(tblAuthMonitorTab.[WatchList], 1) "Watch List"
      ,isnull(tblAuthMonitorTab.[GPSMonitor], 1) "GPS Monitor"
      ,isnull(tblAuthMonitorTab.[CallDetail], 1) "Inmate Calls"
      ,isnull(tblAuthMonitorTab.[VisitDetail], 1) "Phone Visits"
      ,isnull(tblAuthMonitorTab.[Archive], 1) "Call Archives"
      ,isnull(tblAuthMonitorTab.[SearchWordLists], 1) "Search WordLists"
      ,isnull(tblAuthMessageTab.[AllMessage], 1) "Messages"
      ,isnull(tblAuthMessageTab.[EmailApprove], 1) "Email Approval"
      ,isnull(tblAuthMessageTab.[VoiceMailApprove], 1) "Voicemail Approval"
      ,isnull(tblAuthMessageTab.[VideoMessageApprove], 1) "Video Message Approval"
      ,isnull(tblAuthMessageTab.[Broadcast], 1) "Messages Of Officers"
      ,isnull(tblAuthMessageTab.[SendInmateMessage], 1) "Message To Inmates"
      ,isnull(tblAuthMessageTab.[Config], 1) "Message Configuration"
      ,isnull(tblAuthVideoVisitTab.[Config], 1) "Video Visitation Layout"
      ,isnull(tblAuthVideoVisitTab.[Utilities], 1) "Video Visits"
      ,isnull(tblAuthVideoVisitTab.[InmateForms], 1) "Inmate Forms"
      ,isnull(tblAuthServiceRequestTab.[CreateServiceRequest], 1) "Create Service Request"
      ,isnull(tblAuthServiceRequestTab.[SearchServiceRequest], 1) "Search Service Requests"
      ,isnull(tblAuthServiceRequestTab.[InmateIncidentReport], 1) "Inmate Incident Report"
  FROM [leg_Icon].[dbo].[tblAuthUsers]
   left join [leg_Icon].[dbo].tblAuthFacilityTab on tblAuthUsers.AuthID = tblAuthFacilityTab.AuthID
   left join [leg_Icon].[dbo].tblAuthPhoneTab on tblAuthUsers.AuthID = tblAuthPhoneTab.AuthID
   left join [leg_Icon].[dbo].tblAuthUserTab on tblAuthUsers.AuthID = tblAuthUserTab.AuthID
   left join [leg_Icon].[dbo].tblAuthCallControlTab on tblAuthUsers.AuthID = tblAuthCallControlTab.AuthID
   left join [leg_Icon].[dbo].tblAuthDebitTab on tblAuthUsers.AuthID = tblAuthDebitTab.AuthID
   left join [leg_Icon].[dbo].tblAuthInmateTab on tblAuthUsers.AuthID = tblAuthInmateTab.AuthID
   left join [leg_Icon].[dbo].tblAuthReportTab on tblAuthUsers.AuthID = tblAuthReportTab.AuthID
   left join [leg_Icon].[dbo].[tblAuthMonitorTab] on tblAuthUsers.AuthID = tblAuthMonitorTab.AuthID
   left join [leg_Icon].[dbo].tblAuthMessageTab on tblAuthUsers.AuthID = tblAuthMessageTab.AuthID
   left join [leg_Icon].[dbo].tblAuthVideoVisitTab on tblAuthUsers.AuthID = tblAuthVideoVisitTab.AuthID
   left join [leg_Icon].[dbo].tblAuthServiceRequestTab on tblAuthUsers.AuthID = tblAuthServiceRequestTab.AuthID
  
  where
   tblAuthUsers.authID = @authID 
   

