-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_GrievanceForm]
(
	@InmateID varchar(12),
	@FacilityId int,
	@FormID int
)
AS
	SET NOCOUNT ON;
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
      ,isnull(RequestReviewBy,0) as RequestReviewBy
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
      ,FirstName
      ,LastName
      ,MidName
      ,(FirstName + ' ' + LastName) as Name
      ,T.AMT as TimeZone
      
  FROM [leg_Icon].[dbo].[tblGrievanceForm] R,
   [leg_Icon].[dbo].[tblInmate] I, [leg_Icon].[dbo].[tblFacility] F, [leg_Icon].[dbo].[tblTimeZone] T
				
WHERE I.FacilityId = R.FacilityID and I.InmateID = R.InmateID and
	R.FacilityID = F.FacilityID and F.timeZone = T.ZoneCode and
R.InmateID = @InmateID and R.FormID = @FormID AND  R.FacilityId = @FacilityId and I.status=1;

