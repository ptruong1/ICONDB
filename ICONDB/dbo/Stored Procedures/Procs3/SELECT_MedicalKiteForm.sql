-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_MedicalKiteForm]
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
      ,[BookingNo]
      ,[AliasName]
      ,R.DOB
      ,[RequestDate]
      ,[InmateLocation]
      ,isnull(Dental,0) as Dental
      ,isnull(HIV,0) as HIV
      ,isnull(Medical,0) as Medical
      ,isnull(Psychiatric,0) as Psychiatric
      ,[DescriptOfProblem]
      ,[LengthOfProblem]
      ,isnull(InmateSignature,'') as InmateSignature
      ,[Response]
      ,[ReviewedBy]
      ,isnull(ReviewedDate,GETDATE()) as ReviewedDate
      ,[StaffNote]
      ,[NoteBy]
      ,isnull(NoteDate,GETDATE()) as NoteDate
      ,R.Status
      ,isnull(MDClinic,0) as MDClinic
      ,isnull(Nurse,0) as Nurse
      ,isnull(ChartReview,0) as ChartReview
      ,isnull(MentalHealth,0) as MentalHealth
      ,(FirstName + ' ' + LastName) as Name
      ,T.AMT as TimeZone
      
  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R,
   [leg_Icon].[dbo].[tblInmate] I, [leg_Icon].[dbo].[tblFacility] F, [leg_Icon].[dbo].[tblTimeZone] T
				
WHERE I.FacilityId = R.FacilityID and I.InmateID = R.InmateID and
	R.FacilityID = F.FacilityID and F.timeZone = T.ZoneCode and
R.InmateID = @InmateID and R.FormID = @FormID AND  R.FacilityId = @FacilityId and I.status =1;

