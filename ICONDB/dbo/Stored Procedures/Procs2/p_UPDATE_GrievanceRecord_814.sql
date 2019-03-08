CREATE PROCEDURE [dbo].[p_UPDATE_GrievanceRecord_814]
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
      @OfficerResponseTime datetime,
	  @SupervisorName varchar(50),
      @SupervisorReview varchar(2000),
      
      @SupervisorSignature varchar(50),
	  @SupervisorResponseTime datetime,
      @RequestReviewBy tinyint,
      
      @CommanderResponse varchar(2000),
      @CommanderName varchar(50),
      @CommanderSignature varchar(50),
      @CommanderResponseTime datetime,
      --@FinalSignature varchar(50),
      --@FinalSignatureTime datetime,
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
      ,[OfficerResponseTime] = @OfficerResponseTime
      ,[SupervisorReview] = @SupervisorReview
      ,[SupervisorName] = @SupervisorName
      ,[SupervisorSignature] = @SupervisorSignature
	  ,[SupervisorResponseTime] = @SupervisorResponseTime
      ,[RequestReviewBy] = @RequestReviewBy
      ,[CommanderResponse] = @CommanderResponse
      ,[CommanderName] = @CommanderName
      ,[CommanderSignature] = @CommanderSignature
      ,[CommanderResponseTime] = @CommanderResponseTime
      --,[FinalSignature] = @FinalSignature
      --,[FinalSignatureTime] = @FinalSignatureTime
      ,[Status] = @Status
	  ,[GrievanceTypeID] = @GrievanceTypeID
	        
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

