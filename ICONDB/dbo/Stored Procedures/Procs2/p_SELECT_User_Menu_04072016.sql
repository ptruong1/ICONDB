
CREATE PROCEDURE [dbo].[p_SELECT_User_Menu_04072016]
( 
	@AuthID int
)
AS
SELECT  
	tblAuthUsers.[AuthID]
	,isnull( tblAuthUsers.FacilityConfig,0) "Facility"
      ,isnull( tblAuthUsers.[UserControl],0) "Users"
      ,isnull(tblAuthUsers.[PhoneConfig],0) "Phone Setup"
      ,isnull(tblAuthUsers.[CallControl],0) "Call Control"
      ,isnull(tblAuthUsers.[DebitCard] ,0)"Debit"
      ,isnull(tblAuthUsers.[InmateProfile],0) "Inmate"
      ,isnull(tblAuthUsers.[Report],0) "Report"
      ,isnull(tblAuthUsers.[CallMonitor],0) "Call Monitoring"
      ,isnull(tblAuthUsers.[Messaging],0) "Messaging"
      ,isnull(tblAuthUsers.[VideoVisit],0) "Video"
      ,isnull(tblAuthUsers.[ServiceRequest],0) "Service Request"
      ,isnull(tblAuthUsers.[Admin],0) "Admin"
      ,isnull(tblAuthUsers.[PowerUser],0) "PowerUser"
      ,isnull(tblAuthUsers.[Finance-Auditor],0) "Finance-Auditor"
      ,isnull(tblAuthUsers.[Investigator],0) "Investigator"
      ,isnull(tblAuthUsers.[DataEntry],0) "DataEntry"
      ,isnull(tblAuthUsers.[UserDefine],0) "UserDefine"
	  ,isnull(tblAuthUsers.[MyReport],0) "MyReport"

	  ,isnull(tblAuthFacilityTab.Layout, 1) "Phone Layout"
      ,isnull(tblAuthFacilityTab.Config, 1) "Phone Configure"
      ,isnull(tblAuthFacilityTab.Schedule, 1) "Phone Schedules"
      ,isnull(tblAuthFacilityTab.VideoVisitLayout, 1) "Kiosk Layout"
      ,isnull(tblAuthFacilityTab.VideoVisitSchedule, 1) "Video Visit Schedule"
      ,isnull(tblAuthFacilityTab.PhoneVisitSchedule, 1) "Phone Visit Schedule"
      ,isnull(tblAuthFacilityTab.GeneralInfo, 1) "General Info"
      ,isnull(tblAuthFacilityTab.MobileDeviceLayout, 1) "Mobile Device Layout"
      ,isnull(tblAuthFacilityTab.MobileDeviceSchedule, 1) "Mobile Device Schedule"
      
	  ,isnull(tblAuthUserTab.[CreateUser], 1) "New User"
      ,isnull(tblAuthUserTab.[ListUser], 1) "User List"
      ,isnull(tblAuthUserTab.[SearchUser], 1) "User Search"
      ,isnull(tblAuthUserTab.[ActivityUser], 1) "Activity Log"
      ,isnull(tblAuthUserTab.[OfficerActivity], 1) "Officer Check-In"
	  ,isnull(tblAuthUserTab.[OfficerActivity], 1) "User Activity"
      ,isnull(tblAuthPhoneTab.[ListPhone], 1) "Phone List"
      ,isnull(tblAuthPhoneTab.[SearchPhone], 1) "Search Phone"
      ,isnull(tblAuthPhoneTab.[VisitPhone], 1) "Visit Phones"
      ,isnull(tblAuthCallControlTab.[RestrictedNo], 1) "Restricted Numbers"
      ,isnull(tblAuthCallControlTab.[NonRecordNo], 1) "Non-Recordable Numbers"
      ,isnull(tblAuthCallControlTab.[FreeNo], 1) "Free Calls"
      ,isnull(tblAuthDebitTab.[ListDebit], 1) "Debit Account List"
      ,isnull(tblAuthDebitTab.[SearchDebit], 1)  "Search Debit Acct"
      ,isnull(tblAuthDebitTab.[TransferFund], 1) "Fund Transfer"
      ,isnull(tblAuthInmateTab.[RegisterInmate], 1) "Register"
      ,isnull(tblAuthInmateTab.[ListInmate], 1) "Inmate List"
      ,isnull(tblAuthInmateTab.[SearchInmate], 1) "Search Inmate"
      ,isnull(tblAuthInmateTab.[InmateSuspended], 1) "Suspended Inmates"
	  ,isnull(tblAuthInmateTab.[InmateActivity], 1) "Inmate Activity"
      ,isnull(tblAuthReportTab.[Report], 1) "Reports"
      ,isnull(tblAuthReportTab.[CDR], 1) "Call Detail Report"
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
  FROM [leg_Icon].[dbo].[tblAuthUsers] with(nolock) 
   left join [leg_Icon].[dbo].tblAuthFacilityTab with(nolock)  on tblAuthUsers.AuthID = tblAuthFacilityTab.AuthID
   left join [leg_Icon].[dbo].tblAuthPhoneTab  with(nolock)  on tblAuthUsers.AuthID = tblAuthPhoneTab.AuthID
   left join [leg_Icon].[dbo].tblAuthUserTab with(nolock)  on tblAuthUsers.AuthID = tblAuthUserTab.AuthID
   left join [leg_Icon].[dbo].tblAuthCallControlTab with(nolock)  on tblAuthUsers.AuthID = tblAuthCallControlTab.AuthID
   left join [leg_Icon].[dbo].tblAuthDebitTab with(nolock)  on tblAuthUsers.AuthID = tblAuthDebitTab.AuthID
   left join [leg_Icon].[dbo].tblAuthInmateTab with(nolock)  on tblAuthUsers.AuthID = tblAuthInmateTab.AuthID
   left join [leg_Icon].[dbo].tblAuthReportTab with(nolock)  on tblAuthUsers.AuthID = tblAuthReportTab.AuthID
   left join [leg_Icon].[dbo].[tblAuthMonitorTab] with(nolock)  on tblAuthUsers.AuthID = tblAuthMonitorTab.AuthID
   left join [leg_Icon].[dbo].tblAuthMessageTab with(nolock)  on tblAuthUsers.AuthID = tblAuthMessageTab.AuthID
   left join [leg_Icon].[dbo].tblAuthVideoVisitTab with(nolock)  on tblAuthUsers.AuthID = tblAuthVideoVisitTab.AuthID
   left join [leg_Icon].[dbo].tblAuthServiceRequestTab with(nolock)  on tblAuthUsers.AuthID = tblAuthServiceRequestTab.AuthID
  
  where
   tblAuthUsers.authID = @authID 
   

