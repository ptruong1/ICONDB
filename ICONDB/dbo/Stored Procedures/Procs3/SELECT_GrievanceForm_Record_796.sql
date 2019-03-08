-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_GrievanceForm_Record_796]
(
	@InmateID varchar(12),
	@FacilityId int,
	@FormID int
)
AS
	SET NOCOUNT ON;
SELECT distinct [FormID]
      ,R.FacilityID
      ,R.InmateID
      ,[HousingUnit]
      ,LogNo
      ,Category
      ,(FirstName + ' ' + LastName) as Name
      ,[BookSO]
      ,[InmateLocation]
      ,'Assignment' as Assignment
      ,[Grievance] as AppealSubject
      ,[GvIssue]
	  ,[ActionRequest]
	  ,[GrievanceSignature] as InmateSignatureB
      ,convert(varchar(10),GrievanceReportTime,101) as DateSubmittedB
      
      ,OfficerResponse as AssignedResponseC

      ,[ReceivingOfficerName] as AssignedToC
      ,[ReceivingOfficerSignature] as AssignedTitleC
      ,convert(varchar(10),ReceivedTime,101) as DateAssignedC
      ,convert(varchar(10),FirstLevelDueDate,101) as DateDueC
      
      ,ISNULL(CASE WHEN CONVERT(DATE, FirstInterviewDate) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), FirstInterviewDate, 101) END, '') AS DateInterviewC     
      ,[FirstInterviewLocation] as LocationInterviewC
      
      ,SupervisorReview as InterviewerResponseC
      
      ,[OfficerName] as InterviewerC
      ,[OfficerName] as InterviewerTitleC
      ,[OfficerSignature] as InterviewSignatureC
      ,ISNULL(CASE WHEN CONVERT(DATE, OfficerResponseTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), OfficerResponseTime, 101) END, '') AS DateCompletedC
            
      ,[OfficerName] as ReviewerC
      ,[OfficerName] as ReviewerTitleC
      ,[OfficerSignature] as ReviewerSignatureC
      ,ISNULL(CASE WHEN CONVERT(DATE, AcceptOfficerTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), AcceptOfficerTime, 101) END, '') AS DateReceivedC
      ,[AcceptOfficerSignature] as ReceivedByC
      
      ,RIGHT('0' + CAST(day(AcceptOfficerTime) AS varchar(2)), 2) as DayC
	  ,RIGHT('0'+CAST(MONTH(AcceptOfficerTime) AS varchar(2)),2) as MonthC
	  ,DATEPART(year,AcceptOfficerTime)  as YearC
	  
	  ,[SecondAppeal] as InmateAppealD
	  ,[ApealOfficerSignature] as InmateSignatureD
	  ,ISNULL(CASE WHEN CONVERT(DATE, AppealOfficerResponseTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), AppealOfficerResponseTime, 101) END, '') AS InmateDateSubmittedD
	 	  
	  ,CommanderResponse as AssignedResponseE
	  
	  ,[SupervisorName] as AssignedToE
      ,[SupervisorSignature] as AssignedTitleE
      ,ISNULL(CASE WHEN CONVERT(DATE, SupervisorResponseTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), SupervisorResponseTime, 101) END, '') AS DateAssignedE
      ,ISNULL(CASE WHEN CONVERT(DATE, SecondLevelDueDate) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), SecondLevelDueDate, 101) END, '') AS DateDueE
      ,ISNULL(CASE WHEN CONVERT(DATE, SecondInterviewDate) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), SecondInterviewDate, 101) END, '') AS DateInterviewE
      ,[SecondInterviewLocation] as LocationInterviewE
      
      
      ,Isnull(SheriffResponse,'') as InterviewerResponseE

      ,[CommanderName] as InterviewerE
      ,[CommanderName] as InterviewerTitleE
      ,[CommanderSignature] as InterviewerSignatureE
      ,ISNULL(CASE WHEN CONVERT(DATE, CommanderResponseTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), CommanderResponseTime, 101) END, '') AS DateCompletedE
            
      ,[CommanderName] as ReviewerE
      ,[CommanderName] as ReviewerTitleE
      ,[CommanderSignature] as ReviewerSignatureE
      ,ISNULL(CASE WHEN CONVERT(DATE, CommanderResponseTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), CommanderResponseTime, 101) END, '') AS DateReceivedE
      ,[CommanderSignature] as ReceivedByE
      
      ,RIGHT('0' + CAST(day(CommanderResponseTime) AS varchar(2)), 2) as DayE
	  ,RIGHT('0'+ CAST(MONTH(CommanderResponseTime) AS varchar(2)),2) as MonthE
	  ,DATEPART(year,CommanderResponseTime)  as YearE
       
      ,[ThirdAppeal] as InmateAppealF
	  ,[AppealCommanderSignature] as InmateSignatureF
	  ,ISNULL(CASE WHEN CONVERT(DATE, AppealCommanderTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), AppealCommanderTime, 101) END, '') AS InmateDateSubmittedF
	        
      ,OfficerLastStatement as LastResponse
	  
	  ,RIGHT('0' + CAST(day(SheriffResponseTime) AS varchar(2)), 2) as DayF
	  ,RIGHT('0'+CAST(MONTH(SheriffResponseTime) AS varchar(2)),2) as MonthF
	  
	  ,DATEPART(year,SheriffResponseTime)  as YearF
	  
	  ,[InmateLastStatement] as InmateWithdrawnReason
	  ,[FinalSignature] as InmateSignatureFinal
	  ,ISNULL(CASE WHEN CONVERT(DATE, FinalSignatureTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), FinalSignatureTime, 101) END, '') AS InmateSignatureDateFinal
	  	  
	  ,[SheriffName] as StaffName
      ,[SheriffName] as StaffTitle  
      ,[SheriffSignature] as StaffSignature
      ,ISNULL(CASE WHEN CONVERT(DATE, SheriffResponseTime) = '1900-01-01' THEN '' ELSE CONVERT(CHAR(10), SheriffResponseTime, 101) END, '') AS StaffDateSigned  
                      
      
      ,R.status
      ,isnull(GrievancetypeID,1) as GrievancetypeID
      
      ,T.AMT as TimeZone
      ,F.Location
	  
  FROM [leg_Icon].[dbo].[tblGrievanceForm] R,
   [leg_Icon].[dbo].[tblInmate] I, [leg_Icon].[dbo].[tblFacility] F, [leg_Icon].[dbo].[tblTimeZone] T
				
WHERE I.FacilityId = R.FacilityID and I.InmateID = R.InmateID and
	R.FacilityID = F.FacilityID and F.timeZone = T.ZoneCode and
R.InmateID = @InmateID and R.FormID = @FormID AND  R.FacilityId = @FacilityId

