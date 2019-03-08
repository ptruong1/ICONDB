




CREATE PROCEDURE [dbo].[UPDATE_GrievanceRecord_796]
(
	@FacilityId int
	,@formID int
	,@InmateID Varchar(12)
	
      
      ,@FirstLevelSubmitStatus tinyint
      ,@ReceivingOfficerName varchar(50)
      ,@ReceivingOfficerSignature varchar(50)
      ,@ReceivedTime datetime
      ,@FirstLevelDueDate datetime
      
      ,@FirstLevelInterviewDate datetime
      ,@FirstLevelInterviewStatus tinyint
      
      ,@OfficerName varchar(50)
      ,@OfficerSignature varchar(50)
      ,@OfficerResponseTime datetime
                 
      ,@AcceptOfficerTime datetime
      ,@AcceptOfficerSignature varchar(50)
      
	  ,@OfficerResponse varchar(200)
	  ,@ApealOfficerSignature varchar(50)
	  ,@AppealOfficerResponseTime datetime
	  
	  ,@SecondLevelSubmitStatus tinyint
	  
	  ,@SupervisorName varchar(50)
      ,@SupervisorSignature varchar(50)
      ,@SupervisorResponseTime datetime
      ,@SecondLevelDueDate datetime
      
      ,@SecondLevelInterviewDate date
      
      ,@SecondLevelInterviewStatus tinyint
      
      ,@CommanderName varchar(50)
      ,@CommanderSignature varchar(50)
      ,@CommanderResponseTime datetime
       
      ,@CommanderResponse varchar(200)
	  ,@AppealCommanderSignature varchar(50)
	  ,@AppealCommanderTime datetime
      
      ,@ThirdLevelSubmitStatus tinyint
      
	  ,@ThirdLevelInterviewStatus tinyint
	   
	  ,@SheriffResponse varchar(200)	
	  ,@FinalSignature varchar(50)
	  ,@FinalSignatureTime datetime
	  
	  ,@SheriffName varchar(50)
      ,@SheriffSignature varchar(50)  
      ,@SheriffResponseTime datetime
                
      
      ,@status tinyint
     
)
AS
	
SET NOCOUNT OFF;

   UPDATE leg_Icon_dev.[dbo].[tblGrievanceForm]
   SET 
      FirstLevelSubmitStatus = @FirstLevelSubmitStatus
      ,[ReceivingOfficerName] = @ReceivingOfficerName
      ,[ReceivingOfficerSignature] = @ReceivingOfficerSignature
      ,[ReceivedTime] = @ReceivedTime
      ,FirstLevelDueDate = @FirstLevelDueDate
      
      ,FirstLevelInterviewDate = @FirstLevelInterviewDate
      
      
      ,FirstLevelInterviewStatus = @FirstLevelInterviewStatus
      
      ,[OfficerName] = @OfficerName
      
      ,[OfficerSignature] = @OfficerSignature
      ,[OfficerResponseTime] = @OfficerResponseTime
      
      
      
      ,[AcceptOfficerTime] = @AcceptOfficerTime
      ,[AcceptOfficerSignature] = @AcceptOfficerSignature
      
      
	  
	  ,[OfficerResponse] = @OfficerResponse
	  ,[ApealOfficerSignature] = @ApealOfficerSignature
	  ,[AppealOfficerResponseTime] = @AppealOfficerResponseTime
	  
	  ,SecondLevelSubmitStatus = @SecondLevelSubmitStatus
	  
	  ,[SupervisorName] = @SupervisorName
      ,[SupervisorSignature] = @SupervisorSignature
      ,[SupervisorResponseTime] = @SupervisorResponseTime
      ,SecondLevelDueDate = @SecondLevelDueDate
      
      ,SecondLevelInterviewDate = @SecondLevelInterviewDate
     
      
      ,SecondLevelInterviewStatus = @SecondLevelInterviewStatus
      
      ,[CommanderName] = @CommanderName
   
      ,[CommanderSignature] = @CommanderSignature
      ,[CommanderResponseTime] = @CommanderResponseTime
     
      
      ,[CommanderResponse] = @CommanderResponse
	  ,[AppealCommanderSignature] = @AppealCommanderSignature
	  ,[AppealCommanderTime] = @AppealCommanderTime
      
      ,ThirdLevelSubmitStatus = @ThirdLevelSubmitStatus
      
	  ,ThirdLevelInterviewStatus = @ThirdLevelInterviewStatus   

	  ,[FinalSignature] = @FinalSignature
	  ,[FinalSignatureTime] = @FinalSignatureTime
	  
	  ,[SheriffName] = @SheriffName
      
      ,[SheriffSignature] = @SheriffSignature  
      ,[SheriffResponseTime] = @SheriffResponseTime
                
      
      ,status = @Status
      
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

