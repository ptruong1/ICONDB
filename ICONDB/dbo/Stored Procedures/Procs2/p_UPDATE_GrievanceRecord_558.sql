CREATE PROCEDURE [dbo].[p_UPDATE_GrievanceRecord_558]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@ReceivingOfficerName varchar(50),
      @ReceivedTime  datetime,
      @ReceivingOfficerSignature varchar(50),
      @OfficerResponse varchar(2000),
      @OfficerName varchar(50),
      @OfficerSignature varchar(50),
      @AcceptOfficerSignature varchar(50),
      @AcceptOfficerTime datetime,
      @OfficerResponseTime datetime,
      @AppealOfficerResponseTime datetime,
      @ApealOfficerSignature varchar(50),
      @SupervisorReview varchar(500),
      @SupervisorName varchar(50),
      @SupervisorSignature varchar(50),
      @RequestReviewBy tinyint,
      @AcceptSupervisorResolutionTime datetime,
      @AcceptSupervisorSignature varchar(50),
      @SupervisorResponseTime datetime,
      @AppealSupervisorSignature varchar(50),
      @AppealSupervisorTime datetime,
      @CommanderResponse varchar(2000),
      @CommanderName varchar(50),
      @CommanderSignature varchar(50),
      @CommanderResponseTime datetime,
      @AcceptCommanderTime datetime,
      @AcceptCommanderSignature varchar(50),
      @AppealCommanderSignature varchar(50),
      @AppealCommanderTime datetime,
      @SheriffResponse varchar(2000),
      @SheriffName varchar(50),
      @SheriffResponseTime datetime,
      @SheriffSignature varchar(50),
      @FinalSignature varchar(50),
      @FinalSignatureTime datetime,
      @Status tinyint,
	  @GrievanceTypeID tinyint
)
AS
	
SET NOCOUNT OFF;

   UPDATE [leg_Icon].[dbo].[tblGrievanceForm]
   SET 
      [ReceivingOfficerName] = @ReceivingOfficerName
      ,[ReceivedTime] = @ReceivedTime
      ,[ReceivingOfficerSignature] = @ReceivingOfficerName
      ,[OfficerResponse] = @OfficerResponse
      ,[OfficerName] = @OfficerSignature
      ,[OfficerSignature] = @OfficerSignature
      ,[AcceptOfficerSignature] = @AcceptOfficerSignature
      ,[AcceptOfficerTime] = @AcceptOfficerTime
      ,[OfficerResponseTime] = @OfficerResponseTime
      ,[AppealOfficerResponseTime] = @AppealOfficerResponseTime
      ,[ApealOfficerSignature] = @ApealOfficerSignature
      ,[SupervisorReview] = @SupervisorReview
      ,[SupervisorName] = @SupervisorName
      ,[SupervisorSignature] = @SupervisorSignature
      ,[RequestReviewBy] = @RequestReviewBy
      ,[AcceptSupervisorResolutionTime] = @AcceptSupervisorResolutionTime
      ,[AcceptSupervisorSignature] = @AcceptSupervisorSignature
      ,[SupervisorResponseTime] = @SupervisorResponseTime
      ,[AppealSupervisorSignature] = @AppealSupervisorSignature
      ,[AppealSupervisorTime] = @AppealSupervisorTime
      ,[CommanderResponse] = @CommanderResponse
      ,[CommanderName] = @CommanderName
      ,[CommanderSignature] = @CommanderSignature
      ,[CommanderResponseTime] = @CommanderResponseTime
      ,[AcceptCommanderTime] = @AcceptCommanderTime
      ,[AcceptCommanderSignature] = @AcceptCommanderSignature
      ,[AppealCommanderSignature] = @AppealCommanderSignature
      ,[AppealCommanderTime] = @AppealCommanderTime
      ,[SheriffResponse] = @SheriffResponse
      ,[SheriffName] = @SheriffName
      ,[SheriffResponseTime] = @SheriffResponseTime
      ,[SheriffSignature] = @SheriffSignature
      ,[FinalSignature] = @FinalSignature
      ,[FinalSignatureTime] = @FinalSignatureTime
      ,[Status] = @Status
	  ,[GrievanceTypeID] = @GrievanceTypeID
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

