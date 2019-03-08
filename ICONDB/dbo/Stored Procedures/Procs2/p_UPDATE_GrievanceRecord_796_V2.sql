




CREATE PROCEDURE [dbo].[p_UPDATE_GrievanceRecord_796_V2]
(
	 @FacilityId int
	,@formID int
	,@InmateID Varchar(12)
	,@LogNo Varchar(25)
	,@Category Varchar(25)
	
      ,@OfficerResponse varchar(2000) 

      ,@ReceivingOfficerName varchar(50)
      ,@ReceivingOfficerSignature varchar(50) 
      ,@ReceivedTime varchar(50) 
      ,@FirstLevelDueDate varchar(50)
      
      ,@FirstInterviewDate varchar(50) 
      ,@FirstInterviewLocation varchar(50)
      
      ,@SupervisorReview varchar(2000) 
      
      
      ,@OfficerName varchar(50) 
      ,@OfficerSignature varchar(50)
      ,@OfficerResponseTime varchar(50)
    
      ,@AcceptOfficerTime varchar(50) 
      ,@AcceptOfficerSignature varchar(50) 
      
	  ,@SecondAppeal varchar(1000) 
	  ,@ApealOfficerSignature varchar(50)
	  ,@AppealOfficerResponseTime varchar(50)
	  
	  ,@CommanderResponse varchar(2000) -- appeal lvl 2
	  
	  ,@SupervisorName varchar(50) 
      ,@SupervisorSignature varchar(50)
      ,@SupervisorResponseTime varchar(50)
	  ,@SecondLevelDueDate varchar(50) 
      
      ,@SecondInterviewDate varchar(50) 
      ,@SecondInterviewLocation varchar(50)
      
      
      ,@SheriffResponse varchar(2000) 

      
      ,@CommanderName varchar(50)
      ,@CommanderSignature varchar(50)
      ,@CommanderResponseTime varchar(50)
            
      ,@ThirdAppeal varchar(1000)
	  ,@AppealCommanderSignature varchar(50)
	  ,@AppealCommanderTime varchar(50)
      
      ,@OfficerLastStatement varchar(500)
	  
	 
	  ,@InmateLastStatement varchar(500)
	  ,@FinalSignature varchar(50) 
	  ,@FinalSignatureTime varchar(50) 
	  
	  ,@SheriffName varchar(50)
      
      ,@SheriffSignature varchar(50)
      ,@SheriffResponseTime varchar(50)
                
      
      ,@status tinyint
	  )
  
     

AS
	
SET NOCOUNT OFF;

   UPDATE leg_Icon.[dbo].[tblGrievanceForm]
   SET
	 LogNo = @LogNo
	,Category =@Category  
    ,OfficerResponse = @OfficerResponse

    ,ReceivingOfficerName  = @ReceivingOfficerName
    ,ReceivingOfficerSignature  = @ReceivingOfficerSignature
    ,ReceivedTime  = @ReceivedTime
    ,FirstLevelDueDate  = @FirstLevelDueDate 
      
    ,FirstInterviewDate  = @FirstInterviewDate 
    ,FirstInterviewLocation  = @FirstInterviewLocation 
      
    ,SupervisorReview  = @SupervisorReview 
      
      
    ,OfficerName  = @OfficerName  
    ,OfficerSignature  = @OfficerSignature 
    ,OfficerResponseTime  = @OfficerResponseTime 
    
    ,AcceptOfficerTime  = @AcceptOfficerTime 
    ,AcceptOfficerSignature  = @AcceptOfficerSignature
      
	,SecondAppeal  = @SecondAppeal
	,ApealOfficerSignature  = @ApealOfficerSignature 
	,AppealOfficerResponseTime  = @AppealOfficerResponseTime
	  
	,CommanderResponse  = @CommanderResponse
	  
	,SupervisorName  = @SupervisorName 
     ,SupervisorSignature = @SupervisorSignature 
     ,SupervisorResponseTime = @SupervisorResponseTime  
     ,SecondLevelDueDate = @SecondLevelDueDate 
      
     ,SecondInterviewDate = @SecondInterviewDate
     ,SecondInterviewLocation = @SecondInterviewLocation 
      
      
     ,SheriffResponse = @SheriffResponse

      
     ,CommanderName = @CommanderName 
     ,CommanderSignature = @CommanderSignature 
     ,CommanderResponseTime = @CommanderResponseTime 
            
     ,ThirdAppeal = @ThirdAppeal 
	,AppealCommanderSignature  = @AppealCommanderSignature
	,AppealCommanderTime  = @AppealCommanderTime 
      
     ,OfficerLastStatement = @OfficerLastStatement
	  
	 
	,InmateLastStatement  = @InmateLastStatement 
	,FinalSignature  = @FinalSignature
	,FinalSignatureTime  = @FinalSignatureTime  
	  
	,SheriffName  = @SheriffName 
      
    ,SheriffSignature  = @SheriffSignature 
    ,SheriffResponseTime  = @SheriffResponseTime 
                
      
    ,status  = @status 
      
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

