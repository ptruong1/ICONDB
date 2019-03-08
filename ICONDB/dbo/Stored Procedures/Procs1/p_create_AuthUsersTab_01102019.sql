
CREATE PROCEDURE [dbo].[p_create_AuthUsersTab_01102019]
(
	@AuthID bigint,
	@FacilityConfig  bit,
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
	@Kites bit,
	@MyReport bit,

	@Layout bit,
	@Config bit,
	@Schedule bit,
	@GeneralInfo bit,
	@VideoVisitLayout bit,
	@VideoVisitSchedule bit,
	@PhoneVisitSchedule bit,
	@MobileDeviceLayout bit,
	@MobileDeviceSchedule bit,
	
	@CreateUser bit,
	@ListUser bit,
	@SearchUser bit,
	@ActivityUser bit,
	@OfficerActivity bit,
	@UserRole bit,
	
	@ListPhone bit,
	@SearchPhone bit,
	@VisitPhone bit,
	
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
	@PhoneVisit bit,
	@SearchWordLists bit,
	
	@AllMessage bit,
	@EmailApprove bit,
	@VoiceMailApprove bit,
	@VideoMessageApprove bit,
	@Broadcast bit,
	@SendInmateMessage bit,
	@Configuration bit,
	@PictureExchangeApprove bit,
	
	@ConfigVideo bit,
	--@InmateForms bit,
	@Utilities bit,
	
	@CreateServiceRequest bit,
	@SearchServiceRequest bit,
	@InmateIncidentReport bit,

	@InmateKite bit,
	@MedicalKite bit,
	@Grievance bit,
	@LegalForm bit

)
AS
SET NOCOUNT OFF;
INSERT [tblAuthFacilityTab] ([AuthID],[Config],[Schedule],[Layout],[GeneralInfo],[VideoVisitLayout],[VideoVisitSchedule],[PhoneVisitSchedule],[MobileDeviceLayout],[MobileDeviceSchedule]) 
	VALUES (@AuthID, @Config, @Schedule, @Layout, @GeneralInfo, @VideoVisitLayout, @VideoVisitSchedule, @PhoneVisitSchedule	, @MobileDeviceLayout, @MobileDeviceSchedule);
INSERT [tblAuthUserTab] ([AuthID],[CreateUser],[ListUser],[SearchUser],[ActivityUser],[OfficerActivity],[UserRoles])
	VALUES (@AuthID, @CreateUser, @ListUser, @SearchUser, @ActivityUser, @OfficerActivity, @UserRole)
INSERT [tblAuthPhoneTab] ([AuthID], [ListPhone], [SearchPhone],[VisitPhone])
	VALUES (@AuthID,@ListPhone,@SearchPhone,@VisitPhone)
INSERT [tblAuthCallControlTab] ([AuthID], [RestrictedNo], [NonRecordNo], [FreeNo])
	VALUES (@AuthID, @RestrictedNo, @NonRecordNo, @FreeNo)
INSERT [tblAuthDebitTab] ([AuthID], [ListDebit], [SearchDebit], [TransferFund])
	VALUES (@AuthID, @ListDebit, @SearchDebit, @TransferFund)
INSERT [tblAuthInmateTab] ([AuthID], [RegisterInmate], [ListInmate], [SearchInmate],[InmateSuspended], [InmateActivity])
	VALUES (@AuthID, @RegisterInmate, @ListInmate, @SearchInmate, @InmateSuspended, @InmateActivity)
INSERT [tblAuthReportTab] ([AuthID], [Report], [CDR], [CustomReports])
	VALUES (@AuthID, @Report, @CDR, @CustomReport)
INSERT [tblAuthMonitorTab] ([AuthID], [LiveMonitor], [WatchList], [GPSMonitor],[CallDetail],  [SearchWordLists])
	VALUES (@AuthID, @LiveMonitor, @WatchList,@GPSMonitor, @CallDetail, @SearchWordLists)
INSERT [tblAuthMessageTab] ([AuthID], [AllMessage], [EmailApprove], [VoiceMailApprove], [VideoMessageApprove],[Broadcast],[SendInmateMessage], [Config],[PictureExchangeApprove])
	VALUES (@AuthID, @AllMessage, @EmailApprove, @VoiceMailApprove, @VideoMessageApprove, @Broadcast, @SendInmateMessage,@Configuration, @PictureExchangeApprove)
INSERT [tblAuthVideoVisitTab] ([AuthID], [Config], [Utilities],[PhoneVisit])
	VALUES (@AuthID, @ConfigVideo,  @Utilities, @PhoneVisit)
INSERT [tblAuthServiceRequestTab] ([AuthID], [CreateServiceRequest], [SearchServiceRequest], [InmateIncidentReport])
	VALUES (@AuthID, @CreateServiceRequest, @SearchServiceRequest, @InmateIncidentReport)
INSERT [tblAuthFormTab] ([AuthID], [InmateKite], [MedicalKite], [Grievance], [LegalForm])
	VALUES (@AuthID, @InmateKite, @MedicalKite, @Grievance, @LegalForm)
	


