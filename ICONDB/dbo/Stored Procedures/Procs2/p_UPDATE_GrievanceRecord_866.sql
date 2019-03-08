CREATE PROCEDURE [dbo].[p_UPDATE_GrievanceRecord_866]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@ReceivingOfficerName varchar(50),
      @ReceivedTime  datetime,
      @ReceivingOfficerSignature varchar(50),
            @SupervisorReview varchar(500),
      @SupervisorName varchar(50),
      @SupervisorSignature varchar(50),
 
      
      @SupervisorResponseTime datetime,
      @RequestReviewBy tinyint,
            @SheriffResponse varchar(2000),
      @SheriffName varchar(50),
      @SheriffResponseTime datetime,
      @SheriffSignature varchar(50),
      @FinalSignature varchar(50),
      @FinalSignatureTime datetime,
      @Status tinyint
	  )
AS
	
SET NOCOUNT OFF;

   UPDATE [leg_Icon].[dbo].[tblGrievanceForm]
   SET 
      [ReceivingOfficerName] = @ReceivingOfficerName
      ,[ReceivedTime] = @ReceivedTime
      ,[ReceivingOfficerSignature] = @ReceivingOfficerName
      
      ,[SupervisorReview] = @SupervisorReview
      ,[SupervisorName] = @SupervisorName
      ,[SupervisorSignature] = @SupervisorSignature
      
      
      ,[SupervisorResponseTime] = @SupervisorResponseTime
      ,RequestReviewBy = @RequestReviewBy 
      ,[SheriffResponse] = @SheriffResponse
      ,[SheriffName] = @SheriffName
      ,[SheriffResponseTime] = @SheriffResponseTime
      ,[SheriffSignature] = @SheriffSignature
      ,[FinalSignature] = @FinalSignature
      ,[FinalSignatureTime] = @FinalSignatureTime
      ,[Status] = @Status
	  
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

