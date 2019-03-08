-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_GrievanceRecords_08112016]
(
	@InmateID varchar(12),
	@FacilityId int,
	@Status int
)
AS
	SET NOCOUNT ON;
SET @InmateID	 = rtrim(ltrim(@InmateID))
If (@Status < 0)
Begin	
IF (@InmateID <> '')
Begin
SELECT [FormID]
      ,R.FacilityID
      ,R.InmateID
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
      ,R.status
      ,F.Descript
      ,(FirstName + ' ' + LastName) as Name,
      G.Descript
      
      
  FROM [leg_Icon].[dbo].[tblGrievanceForm] R
   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
   inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
   inner join [leg_Icon].[dbo].[tblGrievanceType] G on isnull(R.GrievancetypeID,1) = G.GrievanceType
WHERE 
	  R.FacilityId = @FacilityId and
	  R.InmateID = @InmateID
	  order by FormID desc
End
	  Else
Begin
SELECT [FormID]
      ,R.FacilityID
      ,R.InmateID
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
      ,R.status
      ,F.Descript
      ,(FirstName + ' ' + LastName) as Name,
      isnull(G.Descript,'1')  as GrievanceDescript
      
  FROM [leg_Icon].[dbo].[tblGrievanceForm] R
   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
	inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
	inner join [leg_Icon].[dbo].[tblGrievanceType] G on isnull(R.GrievancetypeID,1) = G.GrievanceType
				
WHERE 
	  R.FacilityId = @FacilityId 
	  order by FormID desc
	  
End
END
Else
Begin
IF (@InmateID <> '')
Begin
SELECT [FormID]
      ,R.FacilityID
      ,R.InmateID
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
      ,R.status
      ,F.Descript
      ,(FirstName + ' ' + LastName) as Name,
      isnull(G.Descript,'1')  as GrievanceDescript
      
      
  FROM [leg_Icon].[dbo].[tblGrievanceForm] R
   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
	inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
	inner join [leg_Icon].[dbo].[tblGrievanceType] G on isnull(R.GrievancetypeID,1) = G.GrievanceType			
WHERE 
	  R.FacilityId = @FacilityId and
	  R.InmateID = @InmateID and
	  R.status = @Status
	  order by FormID desc
End
	  Else
Begin
SELECT [FormID]
      ,R.FacilityID
      ,R.InmateID
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
      ,R.status
      ,F.Descript
      ,(FirstName + ' ' + LastName) as Name
      ,isnull(G.Descript,'1')  as GrievanceDescript
     
  FROM [leg_Icon].[dbo].[tblGrievanceForm] R
   inner join [leg_Icon].[dbo].[tblInmate] I on R.FacilityId = I.FacilityID and R.InmateID = I.InmateID
	inner join [leg_Icon].[dbo].[tblFormstatus] F on R.Status = F.statusID
	inner join [leg_Icon].[dbo].[tblGrievanceType] G on isnull(R.GrievancetypeID,1) = G.GrievanceType
				
WHERE 
	  R.FacilityId = @FacilityId and
	  R.status = @Status
	  order by FormID desc
End
END
