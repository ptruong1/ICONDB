-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_MedicalKiteForm_796]
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
	  ,RIGHT('0' + CAST(day(RequestDate) AS varchar(2)), 2) as RequestDay
	  ,RIGHT('0'+CAST(MONTH(RequestDate) AS varchar(2)),2) as RequestMonth
	  ,DATEPART(year,RequestDate)  as RequestYear
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
      ,FirstName 
	  ,LastName
      ,T.AMT as TimeZone
      ,F.Location
      ,Fr.MedProvider
	  ,isnull(ReleaseDate,'') as ReleaseDate
	  ,isnull(Copay,0) as Copay
      ,isnull(VisitedClinic,0) as VisitedClinic
      ,isnull(ProviderName,'') as ProviderName
      
  FROM [leg_Icon].[dbo].[tblMedicalKiteForm] R,
   [leg_Icon].[dbo].[tblInmate] I, [leg_Icon].[dbo].[tblFacility] F, [leg_Icon].[dbo].[tblTimeZone] T, 
	[leg_Icon].[dbo].[tblFacilityForms] Fr			
WHERE I.FacilityId = R.FacilityID and I.InmateID = R.InmateID and
	R.FacilityID = F.FacilityID and F.timeZone = T.ZoneCode and
R.InmateID = @InmateID and R.FormID = @FormID AND  R.FacilityId = @FacilityId
and Fr.FacilityID = R.FacilityID
