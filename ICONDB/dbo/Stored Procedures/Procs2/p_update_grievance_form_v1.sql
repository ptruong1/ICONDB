-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_grievance_form_v1]
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
	--SET @GrievanceDate = dateadd(hour,@timeZone, @GrievanceReportTime ); 
	--SET @RequestTime = dateadd(hour,@timeZone, @GrievanceReportTime );
	
	if(@Status =3)	
		Update  [tblGrievanceForm] set [Status] = @Status,AppealOfficerResponseTime=@StatusDate,ApealOfficerSignature=@InmateSignature  where FormID = @FormID and [Status] =2 ;
    Else if(@Status =5)
		Update  [tblGrievanceForm] set [Status] = @Status, AppealSupervisorTime=@StatusDate,AppealSupervisorSignature =@InmateSignature  where FormID = @FormID  and [Status] =4 ;     
	Else if(@Status =7)
		Update  [tblGrievanceForm] set [Status] = @Status, AppealCommanderTime =@StatusDate,AppealCommanderSignature  =@InmateSignature  where FormID = @FormID  and [Status] =6 ;     
	Else if(@Status =10)
		Update  [tblGrievanceForm] set [Status] = @Status, AcceptOfficerTime =@StatusDate, AcceptOfficerSignature =@InmateSignature  where FormID = @FormID  ;      
	
	Else if(@Status =15)
	 begin
		select @currentStatus = [status] from [tblGrievanceForm] where FormID = @formID
		if(@currentStatus = 4)			
			Update  [tblGrievanceForm] set [Status] = @Status, AcceptSupervisorResolutionTime =@StatusDate, AcceptSupervisorSignature =@InmateSignature   where FormID = @FormID ;     
		else if (@currentStatus = 6)
			Update  [tblGrievanceForm] set [Status] = @Status, AcceptCommanderTime =@StatusDate, AcceptCommanderSignature =@InmateSignature     where FormID = @FormID ;          
		else
			Update  [tblGrievanceForm] set [Status] = @Status, FinalSignatureTime =@StatusDate, FinalSignature =@InmateSignature   where FormID = @FormID  and [Status]=8 ;    
	 end
	else
		Update  [tblGrievanceForm] set [Status] = @Status  where FormID = @FormID
	
	Select  [FormID]
      ,G.[FacilityID]
      ,G.[InmateID], (I.FirstName + ' ' + I.LastName) as InmateName
      ,[BookSO]
      ,[InmateLocation]
      ,[HousingUnit]
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




