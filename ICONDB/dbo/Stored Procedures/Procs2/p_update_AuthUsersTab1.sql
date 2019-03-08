CREATE PROCEDURE  [dbo].[p_update_AuthUsersTab1]
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
	update [tblAuthFacilityTab]
			set [Config] =@Config,
				[Schedule] = @Schedule,
				[Layout] = @Layout
		   where ([AuthID] =@AuthID)
	update [tblAuthUserTab]
			set [CreateUser] = @CreateUser,
				[ListUser] = @ListUser,
				[SearchUser] = @SearchUser,
				[ActivityUser] = @ActivityUser,
				[OfficerActivity] =@OfficerActivity
			where ([AuthID] =@AuthID)
	update [tblAuthPhoneTab] 
			set [ListPhone] = @ListPhone,
				[SearchPhone] =@SearchPhone
			where ([AuthID] =@AuthID)
	update [tblAuthCallControlTab]
			set [RestrictedNo] = @RestrictedNo,
			    [NonRecordNo] = @NonRecordNo,
			    [FreeNo] = @FreeNo
			where ([AuthID] =@AuthID)
	update 	[tblAuthDebitTab] 
			set [ListDebit] = @ListDebit,
			    [SearchDebit] = @SearchDebit,
			    [TransferFund] = @TransferFund
			where ([AuthID] =@AuthID)
	update	[tblAuthInmateTab] 
			set [RegisterInmate] = @RegisterInmate,
				[ListInmate] = @ListInmate,
			    [SearchInmate] = @SearchInmate,
			    [InmateSuspended] = @InmateSuspended
			where ([AuthID] =@AuthID)
	update [tblAuthReportTab] 
			set [Report] = @Report,
				[CDR] = @CDR
			where ([AuthID] =@AuthID)
	update [tblAuthMonitorTab]
			set [LiveMonitor] = @LiveMonitor,
			    [WatchList] = @WatchList,
			    [GPSMonitor] = @WatchList,
			    [CallDetail] =@CallDetail,
			    [VisitDetail] = @VisitDetail,
			    [Archive] = @Archive,
			    [SearchWordLists] = @SearchWordLists
			 where ([AuthID] =@AuthID)
	update [tblAuthMessageTab] 
			set [AllMessage] = @AllMessage,
				[EmailApprove] = @EmailApprove,
				[VoiceMailApprove] = @VoiceMailApprove,
				[VideoMessageApprove] = @VideoMessageApprove,
				[Broadcast] = @Broadcast,
				[SendInmateMessage] = @SendInmateMessage,
				[Config] = @Configuration
		    where ([AuthID] =@AuthID)
	update [tblAuthVideoVisitTab] 
			set [Config] = @Config,
				[InmateForms] = @InmateForms,
				[Utilities] = @Utilities
		    where ([AuthID] =@AuthID)
	update [tblAuthServiceRequestTab]
			set [CreateServiceRequest] = @CreateServiceRequest,
			    [SearchServiceRequest] = @ServiceRequest,
			    [InmateIncidentReport] = @InmateIncidentReport			
			where ([AuthID] =@AuthID)
End


