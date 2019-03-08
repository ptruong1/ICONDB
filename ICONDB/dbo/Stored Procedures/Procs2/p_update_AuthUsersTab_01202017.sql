CREATE PROCEDURE  [dbo].[p_update_AuthUsersTab_01202017]
	(
	@AuthID bigint,
	
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
	@PictureExchangeApprove bit,
	
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
	@ServiceRequest bit
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
		    [ServiceRequest] = @ServiceRequest
		 where ([AuthID] =@AuthID)
End
Begin
	if (exists (select AuthID from tblAuthFacilityTab where AuthID =@AuthID))
		begin
			update [tblAuthFacilityTab]
					set [Config] =@Config,
						[Schedule] = @Schedule,
						[Layout] = @Layout,
						[GeneralInfo] =@GeneralInfo,
						[VideoVisitLayout] = @VideoVisitLayout,
						[VideoVisitSchedule] = @VideoVisitSchedule,
						[PhoneVisitSchedule] = @PhoneVisitSchedule,
						[MobileDeviceLayout] =@MobileDeviceLayout,
						[MobileDeviceSchedule] =@MobileDeviceSchedule
			where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthFacilityTab] ([AuthID],[Config],[Schedule],[Layout],[GeneralInfo],[VideoVisitLayout],[VideoVisitSchedule],[PhoneVisitSchedule],[MobileDeviceLayout],[MobileDeviceSchedule]) 
			VALUES (@AuthID, @Config, @Schedule, @Layout, @GeneralInfo, @VideoVisitLayout, @VideoVisitSchedule, @PhoneVisitSchedule	, @MobileDeviceLayout, @MobileDeviceSchedule);
		end

End
Begin
	if (exists (select AuthID from tblAuthUserTab where AuthID =@AuthID))
		begin
		update [tblAuthUserTab]
				set [CreateUser] = @CreateUser,
					[ListUser] = @ListUser,
					[SearchUser] = @SearchUser,
					[ActivityUser] = @ActivityUser,
					[OfficerActivity] =@OfficerActivity
				where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthUserTab] ([AuthID],[CreateUser],[ListUser],[SearchUser],[ActivityUser],[OfficerActivity])
			VALUES (@AuthID, @CreateUser, @ListUser, @SearchUser, @ActivityUser, @OfficerActivity)
		end
		
End	
Begin
	if (exists (select AuthID from tblAuthPhoneTab where AuthID =@AuthID))
		begin
			update [tblAuthPhoneTab] 
				set [ListPhone] = @ListPhone,
					[SearchPhone] =@SearchPhone,
					[VisitPhone] =@VisitPhone
				where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthPhoneTab] ([AuthID], [ListPhone], [SearchPhone],[VisitPhone])
			VALUES (@AuthID,@ListPhone,@SearchPhone,@VisitPhone)
		end
End	
Begin
	if (exists (select AuthID from tblAuthCallControlTab where AuthID =@AuthID))
		begin
		update [tblAuthCallControlTab]
			set [RestrictedNo] = @RestrictedNo,
			    [NonRecordNo] = @NonRecordNo,
			    [FreeNo] = @FreeNo
			where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthCallControlTab] ([AuthID], [RestrictedNo], [NonRecordNo], [FreeNo])
			VALUES (@AuthID, @RestrictedNo, @NonRecordNo, @FreeNo)
		end

	
End	
Begin
	if (exists (select AuthID from tblAuthDebitTab where AuthID =@AuthID))
		begin
			update 	[tblAuthDebitTab] 
			set [ListDebit] = @ListDebit,
			    [SearchDebit] = @SearchDebit,
			    [TransferFund] = @TransferFund
			where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthDebitTab] ([AuthID], [ListDebit], [SearchDebit], [TransferFund])
			VALUES (@AuthID, @ListDebit, @SearchDebit, @TransferFund)
		end
	
End	
Begin
	if (exists (select AuthID from tblAuthInmateTab where AuthID =@AuthID))
		begin
			update	[tblAuthInmateTab] 
			set [RegisterInmate] = @RegisterInmate,
				[ListInmate] = @ListInmate,
			    [SearchInmate] = @SearchInmate,
			    [InmateSuspended] = @InmateSuspended,
			    [InmateActivity] = @InmateActivity
			where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthInmateTab] ([AuthID], [RegisterInmate], [ListInmate], [SearchInmate],[InmateSuspended], [InmateActivity])
			VALUES (@AuthID, @RegisterInmate, @ListInmate, @SearchInmate, @InmateSuspended, @InmateActivity)
		end

End	
Begin
	if (exists (select AuthID from tblAuthReportTab where AuthID =@AuthID))
		begin
			update [tblAuthReportTab] 
			set [Report] = @Report,
				[CDR] = @CDR,
				[CustomReports]= @CustomReport
			where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthReportTab] ([AuthID], [Report], [CDR], [CustomReports])
			VALUES (@AuthID, @Report, @CDR, @CustomReport)
		end
	
End	
Begin
	if (exists (select AuthID from tblAuthMonitorTab where AuthID =@AuthID))
		begin
			update [tblAuthMonitorTab]
			set [LiveMonitor] = @LiveMonitor,
			    [WatchList] = @WatchList,
			    [GPSMonitor] = @WatchList,
			    [CallDetail] =@CallDetail,
			    [VisitDetail] = @VisitDetail,
			    [Archive] = @Archive,
			    [SearchWordLists] = @SearchWordLists
			 where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthMonitorTab] ([AuthID], [LiveMonitor], [WatchList], [GPSMonitor],[CallDetail],[VisitDetail], [Archive], [SearchWordLists])
			VALUES (@AuthID, @LiveMonitor, @WatchList,@GPSMonitor, @CallDetail, @VisitDetail, @Archive, @SearchWordLists)
		end
	
End	
Begin
	if (exists (select AuthID from tblAuthMessageTab where AuthID =@AuthID))
		begin
			update [tblAuthMessageTab] 
			set [AllMessage] = @AllMessage,
				[EmailApprove] = @EmailApprove,
				[VoiceMailApprove] = @VoiceMailApprove,
				[VideoMessageApprove] = @VideoMessageApprove,
				[Broadcast] = @Broadcast,
				[SendInmateMessage] = @SendInmateMessage,
				[Config] = @Configuration,
				[PictureExchangeApprove] =@PictureExchangeApprove
		    where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthMessageTab] ([AuthID], [AllMessage], [EmailApprove], [VoiceMailApprove], [VideoMessageApprove],[Broadcast],[SendInmateMessage], [Config],[PictureExchangeApprove])
			VALUES (@AuthID, @AllMessage, @EmailApprove, @VoiceMailApprove, @VideoMessageApprove, @Broadcast, @SendInmateMessage,@Configuration, @PictureExchangeApprove)
		end
	
End	
Begin
		if (exists (select AuthID from tblAuthVideoVisitTab where AuthID =@AuthID))
			begin
				update [tblAuthVideoVisitTab] 
				set [Config] = @ConfigVideo,
					[InmateForms] = @InmateForms,
					[Utilities] = @Utilities
				where ([AuthID] =@AuthID)
			end
		else
			begin
				INSERT [tblAuthVideoVisitTab] ([AuthID], [Config],[InmateForms], [Utilities])
				VALUES (@AuthID, @ConfigVideo, @InmateForms, @Utilities)
			end
		
	End	
Begin
		if (exists (select AuthID from tblAuthServiceRequestTab where AuthID =@AuthID))
			begin
				update [tblAuthServiceRequestTab]
			set [CreateServiceRequest] = @CreateServiceRequest,
			    [SearchServiceRequest] = @ServiceRequest,
			    [InmateIncidentReport] = @InmateIncidentReport			
			where ([AuthID] =@AuthID)
			end
		else
			begin
				INSERT [tblAuthServiceRequestTab] ([AuthID], [CreateServiceRequest], [SearchServiceRequest], [InmateIncidentReport])
				VALUES (@AuthID, @CreateServiceRequest, @SearchServiceRequest, @InmateIncidentReport)
			end
	
End
		
	
	
	
	


