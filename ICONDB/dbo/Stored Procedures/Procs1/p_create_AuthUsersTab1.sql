
CREATE PROCEDURE [dbo].[p_create_AuthUsersTab1]
(
	@AuthID bigint,
	@Layout bit,
	@Config bit,
	@Schedule bit,
	
	
	@CreateUser bit,
	@ListUser bit,
	@SearchUser bit,
	@ActivityUser bit,
	@OfficerActivity bit,
	
	@ListPhone bit,
	@SearchPhone bit,
	
	@RestrictedNo bit,
	@NonRecordNo bit,
	@FreeNo bit,
	
	@ListDebit bit,
	@SearchDebit bit,
	@TransferFund bit,
	
	@RegisterInmate bit,
	@ListInmate bit,
	@SearchInmate bit,
	@InmateSuspended bit,
	
	@Report bit,
	@CDR bit,
	
	@LiveMonitor bit,
	@WatchList bit,
	@GPSMonitor bit,
	@CallDetail bit,
	@VisitDetail bit,
	@Archive bit,
	@SearchWordLists bit,
	
	@AllMessage bit,
	@EmailApprove bit,
	@VoiceMailApprove bit,
	@VideoMessageApprove bit,
	@Broadcast bit,
	@SendInmateMessage bit,
	@Configuration bit,
	
	@ConfigVideo bit,
	@InmateForms bit,
	@Utilities bit,
	
	@CreateServiceRequest bit,
	@SearchServiceRequest bit,
	@InmateIncidentReport bit,
	
	@FacilityConfig bit,
	@UserControl bit, 
	@PhoneConfig bit,
	@CallControl bit, 
	@DebitCard bit, 
	@InmateProfile bit,
	@Reports bit, 
	@CallMonitor bit, 
	@Messaging Bit, 
	@VideoVisit Bit, 
	@ServiceRequest bit,
	
	@Admin bit,
	@PowerUser bit,
	@Finance_Auditor bit,
	@Investigator bit,
	@DataEntry bit,
	@UserDefine bit
)
AS
SET NOCOUNT OFF;
INSERT [tblAuthFacilityTab] ([AuthID],[Config],[Schedule],[Layout]) 
	VALUES (@AuthID, @Config, @Schedule, @Layout);
INSERT [tblAuthUserTab] ([AuthID],[CreateUser],[ListUser],[SearchUser],[ActivityUser],[OfficerActivity])
	VALUES (@AuthID, @CreateUser, @ListUser, @SearchUser, @ActivityUser, @OfficerActivity)
INSERT [tblAuthPhoneTab] ([AuthID], [ListPhone], [SearchPhone])
	VALUES (@AuthID,@ListPhone,@SearchPhone)
INSERT [tblAuthCallControlTab] ([AuthID], [RestrictedNo], [NonRecordNo], [FreeNo])
	VALUES (@AuthID, @RestrictedNo, @NonRecordNo, @FreeNo)
INSERT [tblAuthDebitTab] ([AuthID], [ListDebit], [SearchDebit], [TransferFund])
	VALUES (@AuthID, @ListDebit, @SearchDebit, @TransferFund)
INSERT [tblAuthInmateTab] ([AuthID], [RegisterInmate], [ListInmate], [SearchInmate],[InmateSuspended])
	VALUES (@AuthID, @RegisterInmate, @ListInmate, @SearchInmate, @InmateSuspended)
INSERT [tblAuthReportTab] ([AuthID], [Report], [CDR])
	VALUES (@AuthID, @Report, @CDR)
INSERT [tblAuthMonitorTab] ([AuthID], [LiveMonitor], [WatchList], [GPSMonitor],[CallDetail],[VisitDetail], [Archive], [SearchWordLists])
	VALUES (@AuthID, @LiveMonitor, @WatchList,@GPSMonitor, @CallDetail, @VisitDetail, @Archive, @SearchWordLists)
INSERT [tblAuthMessageTab] ([AuthID], [AllMessage], [EmailApprove], [VoiceMailApprove], [VideoMessageApprove],[Broadcast],[SendInmateMessage], [Config])
	VALUES (@AuthID, @AllMessage, @EmailApprove, @VoiceMailApprove, @VideoMessageApprove, @Broadcast, @SendInmateMessage,@Configuration)
INSERT [tblAuthVideoVisitTab] ([AuthID], [Config],[InmateForms], [Utilities])
	VALUES (@AuthID, @ConfigVideo, @InmateForms, @Utilities)
INSERT [tblAuthServiceRequestTab] ([AuthID], [CreateServiceRequest], [SearchServiceRequest], [InmateIncidentReport])
	VALUES (@AuthID, @CreateServiceRequest, @SearchServiceRequest, @InmateIncidentReport)
BEGIN
	update [tblAuthUsers] 
		set [FacilityConfig] = @FacilityConfig, 
		    [UserControl] =@UserControl, 
		    [PhoneConfig] =@PhoneConfig,
		    [CallControl] =@CallControl,
		    [DebitCard] =@DebitCard,
		    [InmateProfile] =@InmateProfile,
		    [Report] =@Reports,
		    [CallMonitor] = @CallMonitor,
		    [Messaging] =@Messaging,
		    [VideoVisit] =@VideoVisit,
		    [ServiceRequest] = @ServiceRequest,
		    
		    [Admin] = @Admin,
		    [PowerUser] = @PowerUser,
		    [Finance-Auditor] = @Finance_Auditor,
		    [Investigator] = @Investigator,
		    [DataEntry] = @DataEntry,
		    [UserDefine] = @UserDefine
	where ([AuthID] =@AuthID)
End


