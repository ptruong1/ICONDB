
CREATE PROCEDURE [dbo].[p_create_AuthUsersTab_08182016]
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
	@InmateActivity bit,
	
	@Report bit,
	@CDR bit,
	@CustomReport bit,
	
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
	@InmateIncidentReport bit

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
INSERT [tblAuthInmateTab] ([AuthID], [RegisterInmate], [ListInmate], [SearchInmate],[InmateSuspended], [InmateActivity])
	VALUES (@AuthID, @RegisterInmate, @ListInmate, @SearchInmate, @InmateSuspended, @InmateActivity)
INSERT [tblAuthReportTab] ([AuthID], [Report], [CDR], [CustomReports])
	VALUES (@AuthID, @Report, @CDR, @CustomReport)
INSERT [tblAuthMonitorTab] ([AuthID], [LiveMonitor], [WatchList], [GPSMonitor],[CallDetail],[VisitDetail], [Archive], [SearchWordLists])
	VALUES (@AuthID, @LiveMonitor, @WatchList,@GPSMonitor, @CallDetail, @VisitDetail, @Archive, @SearchWordLists)
INSERT [tblAuthMessageTab] ([AuthID], [AllMessage], [EmailApprove], [VoiceMailApprove], [VideoMessageApprove],[Broadcast],[SendInmateMessage], [Config])
	VALUES (@AuthID, @AllMessage, @EmailApprove, @VoiceMailApprove, @VideoMessageApprove, @Broadcast, @SendInmateMessage,@Configuration)
INSERT [tblAuthVideoVisitTab] ([AuthID], [Config],[InmateForms], [Utilities])
	VALUES (@AuthID, @ConfigVideo, @InmateForms, @Utilities)
INSERT [tblAuthServiceRequestTab] ([AuthID], [CreateServiceRequest], [SearchServiceRequest], [InmateIncidentReport])
	VALUES (@AuthID, @CreateServiceRequest, @SearchServiceRequest, @InmateIncidentReport)
	


