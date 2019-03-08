-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_grievance_form_v2]
		   @FacilityID int,	
		   @FormID int,
           @Status tinyint,
           @InmateSignature varchar(50)
           
AS
BEGIN
	Declare  @timeZone tinyint , @StatusDate datetime, @currentStatus tinyint;
	SET @timeZone =0;
	SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID );
	SET @StatusDate =  dateadd(hour,@timeZone, GETDATE());
		
	if(@Status = 125)
		Update  [tblGrievanceForm] set [Status] = @Status, AcceptOfficerTime =@StatusDate, AcceptOfficerSignature =@InmateSignature  where FormID = @FormID  ; 
	else if (@Status = 126)	
		Update  [tblGrievanceForm] set [Status] = @Status, AppealOfficerResponseTime =@StatusDate, ApealOfficerSignature =@InmateSignature  where FormID = @FormID
	else if (@Status = 140)	
		Update  [tblGrievanceForm] set [Status] = @Status, AcceptSupervisorResolutionTime =@StatusDate, AcceptSupervisorSignature =@InmateSignature where FormID = @FormID
	else if (@Status = 142)
		Update  [tblGrievanceForm] set [Status] = @Status, AppealSupervisorTime=@StatusDate,AppealSupervisorSignature =@InmateSignature  where FormID = @FormID  ;     
	else if (@Status = 146)
		Update  [tblGrievanceForm] set [Status] = @Status, FinalSignatureTime =@StatusDate, FinalSignature =@InmateSignature   where FormID = @FormID ;  

	--Update  [tblGrievanceForm] set [Status] = @Status  where FormID = @FormID ;
	
	Select  [FormID]
      ,G.[FacilityID]
      ,G.[InmateID], (I.FirstName + ' ' + I.LastName) as InmateName
      ,[BookSO]
      ,[InmateLocation]
      ,[HousingUnit]
	  ,G.[FormReference]
      ,[Grievance]
      ,[GrievanceReportTime]
      ,[GrievanceSignature]
      ,[ReceivingOfficerName]
      ,[ReceivedTime]
      ,[ReceivingOfficerSignature]
      ,[OfficerResponse]
      ,[OfficerName]
      ,[OfficerSignature]
      ,[AcceptOfficerSignature]
      ,[AcceptOfficerTime]
      ,[OfficerResponseTime]
      ,[AppealOfficerResponseTime]
      ,[ApealOfficerSignature]
      ,[SupervisorReview]
      ,[SupervisorName]
      ,[SupervisorSignature]
      ,[RequestReviewBy]
      ,[AcceptSupervisorResolutionTime]
      ,[AcceptSupervisorSignature]
      ,[SupervisorResponseTime]
      ,[AppealSupervisorSignature]
      ,[AppealSupervisorTime]
      ,[CommanderResponse]
      ,[CommanderName]
      ,[CommanderSignature]
      ,[CommanderResponseTime]
      ,[AcceptCommanderTime]
      ,[AcceptCommanderSignature]
      ,[AppealCommanderSignature]
      ,[AppealCommanderTime]
      ,[SheriffResponse]
      ,[SheriffName]
      ,[SheriffResponseTime]
      ,[SheriffSignature]
      ,[FinalSignature]
      ,[FinalSignatureTime]
      ,G.[Status] as [StatusID]                  
       ,F.Descript as [Status] 
	   ,T.Descript as GrievanceType
		from [tblGrievanceForm] G  with(nolock) inner join tblInmate  I  with(nolock) on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F  with(nolock) on (isnull(G.status,1) = F.statusID)
		   Inner join tblGrievanceType T  with(nolock) on (G.GrievancetypeID = T.GrievanceType)
           where FormID =@formID ;
	

END




