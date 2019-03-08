﻿CREATE PROCEDURE  [dbo].[p_update_AuthUsersTab_UserRole]
	(
	@AuthID bigint,
	@OldRoleDescript varchar(25),
	@NewRoleDescript varchar(25),
	@facilityID int,

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
	@DataLink bit,
	
	@LiveMonitor bit,
	@WatchList bit,
	@GPSMonitor bit,
	@CallDetail bit,
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
	@Utilities bit,
	@PhoneVisit bit,

	@CreateServiceRequest bit,
	@SearchServiceRequest bit,
	@InmateIncidentReport bit,

	@InmateKite bit,
	@MedicalKite bit,
	@Grievance bit,
	@LegalForm bit,

	@UserID varchar(25),
	@UserIP varchar(25)
)
AS
SET NOCOUNT OFF;
Declare  @UserAction varchar(200) ;

Begin
	if @OldRoleDescript <> @NewRoleDescript
begin
	If ((select count(*) from tblUserRole where RoleDescript = @NewRoleDescript and facilityId = @facilityId) > 0)
		begin
			Return -1
		end
		else update tblUserRole set RoleDescript = @NewRoleDescript where RoleAuthID = @AuthId
	end
end
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
		    [Kites] = @Kites,
			[MyReport] =@MyReport
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
					[OfficerActivity] =@OfficerActivity,
					[UserRoles] = @UserRole
				where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthUserTab] ([AuthID],[CreateUser],[ListUser],[SearchUser],[ActivityUser],[OfficerActivity], [UserRoles])
			VALUES (@AuthID, @CreateUser, @ListUser, @SearchUser, @ActivityUser, @OfficerActivity, @UserRole)
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
				[CustomReports]= @CustomReport,
				[DataLink] =@DataLink
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
			    [GPSMonitor] = @GPSMonitor,
			    [CallDetail] =@CallDetail,
			  [SearchWordLists] = @SearchWordLists
			 where ([AuthID] =@AuthID)
		end
	else
		begin
			INSERT [tblAuthMonitorTab] ([AuthID], [LiveMonitor], [WatchList], [GPSMonitor],[CallDetail],  [SearchWordLists])
			VALUES (@AuthID, @LiveMonitor, @WatchList,@GPSMonitor, @CallDetail, @SearchWordLists)
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
					[Utilities] = @Utilities,
					[PhoneVisit] = @PhoneVisit
				where ([AuthID] =@AuthID)
			end
		else
			begin
				INSERT [tblAuthVideoVisitTab] ([AuthID], [Config], [Utilities],[PhoneVisit])
				VALUES (@AuthID, @ConfigVideo, @Utilities,@PhoneVisit)
			end
		
	End	
Begin
		if (exists (select AuthID from tblAuthServiceRequestTab where AuthID =@AuthID))
			begin
				update [tblAuthServiceRequestTab]
			set [CreateServiceRequest] = @CreateServiceRequest,
			    [SearchServiceRequest] = @SearchServiceRequest,
			    [InmateIncidentReport] = @InmateIncidentReport			
			where ([AuthID] =@AuthID)
			end
		else
			begin
				INSERT [tblAuthServiceRequestTab] ([AuthID], [CreateServiceRequest], [SearchServiceRequest], [InmateIncidentReport])
				VALUES (@AuthID, @CreateServiceRequest, @SearchServiceRequest, @InmateIncidentReport)
			end
			
	
	
End
Begin
	if (exists (select AuthID from [tblAuthFormTab] where AuthID =@AuthID))
			begin
				update [tblAuthFormTab]
			set [InmateKite] = @InmateKite,
			    [MedicalKite] = @MedicalKite,
			    [Grievance] = @Grievance,
			    [LegalForm]	=@LegalForm	
			where ([AuthID] =@AuthID)
			end
		else
			begin
				INSERT [tblAuthFormTab] ([AuthID], [InmateKite], [MedicalKite], [Grievance], [LegalForm])
				VALUES (@AuthID, @InmateKite, @MedicalKite, @Grievance, @LegalForm)

			end
End
		
Begin
Set @UserAction = 'Update User Role ' + '" ' +cast(@AuthID as varchar(8)) + ' "'
	EXEC  INSERT_ActivityLogs5   @authID,5, @UserAction, @userIP, @UserIP
End

	
	
	


