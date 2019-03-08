-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_grievance_form_relate_accept_inmate_side]
		   @FacilityID int,	
		   @FormID int,
           @InmateSignature varchar(50),
		   @typeAccept tinyint 
		   -- @typeAppeal: 1 = second Accept; 2 = third Accept;  
AS
BEGIN
	Declare  @timeZone tinyint , @StatusDate datetime, @currentStatus tinyint;
	SET @timeZone =0;
	SET @timeZone = (select timeZone from tblfacility where FacilityID =@FacilityID );
	SET @StatusDate =  dateadd(hour,@timeZone, GETDATE());
	--SET @GrievanceDate = dateadd(hour,@timeZone, @GrievanceReportTime ); 
	--SET @RequestTime = dateadd(hour,@timeZone, @GrievanceReportTime );

	if(@typeAccept =1)	
		Update  [tblGrievanceForm] set [Status] = 57, AppealOfficerResponseTime=@StatusDate,ApealOfficerSignature=@InmateSignature, SecondAppeal = null  where FormID = @FormID ;
    Else if(@typeAccept =2)
		Update  [tblGrievanceForm] set [Status] = 58, AppealCommanderTime=@StatusDate, AppealCommanderSignature =@InmateSignature, ThirdAppeal = null  where FormID = @FormID ;     
  	
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
	,G.GrievancetypeID
	,G.RoomBedNo
	,G.GvIssue
	,G.ActionRequest
	,G.FirstLevelDueDate
	,G.SecondLevelDueDate
	,G.FirstLevelInterviewDate
	,G.SecondLevelInterviewDate
	,G.Category
	,G.FirstInterviewDate
	,G.FirstInterviewLocation
	,G.SecondInterviewDate
	,G.SecondInterviewLocation
	,G.SecondAppeal
	,G.ThirdAppeal
	,G.InmateLastStatement
	,G.OfficerLastStatement
	,G.LogNo
                  
        ,F.Descript as [Status] from [tblGrievanceForm] G inner join tblInmate  I on (G.FacilityID = I.FacilityId and G.InmateID =I.InmateID )
           Inner join tblFormstatus F on (G.status = F.statusID)
           where FormID =@formID ;
	
END







