-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmateRequest_LegalRecord_796]
(
	@InmateID varchar(12),
	@FacilityId int,
	@FormID int
)
AS
	SET NOCOUNT ON;

SELECT distinct  R.FormID
	      
      ,R.FacilityID
      ,R.InmateID
	  ,isnull(CourtCert,0) as CourtCert
	  ,LastName as LastName
	  ,FirstName as FirstName
	  ,MidName as Initial
	  --,(Select BookingNo from [leg_Icon].[dbo].[tblInmateBookInfo] where InmateID = @InmateID)  as BookingNo
	  --,(Select AtLocation from [leg_Icon].[dbo].[tblVisitInmateConfig] where InmateID = @InmateID) as InmateLocation
	  ,BookingNo
	  ,HousingUnit as InmateLocation
	  ,[RequestDate]
	  ,[NextCourtDate]
	  ,Isnull(AgencyID,0) as AgencyID
	  ,ISNULL(OtherAgency,0) as OtherAgency
	  ,isnull(Sentence,0) as Sentenced
	  ,isnull(LawyerRepresent,0) LawyerRepresent
	  ,isnull(LawyerType,0) as LawyerType
      ,isnull(CAcriminal,0) as CACriminal
      ,isnull(CAcivil,0) as CACivil
      ,Isnull(FEDcriminal,0) as FedCriminal
      ,Isnull(FEDcivil,0) as FEDCivil
      ,Isnull(OtherState,0) as OtherState
      ,'OtherStateCase' as OtherStateCase
      ,Isnull(Administrative,0) as Administrative
      
      ,isnull(ICE,0) as ICE
      ,Isnull(OtherCase,0) as OtherCase
      ,'OtherKind' as OtherKind
      
      ,Isnull(RecordDate,'') as RecordDate
      ,Isnull(ReceivedDate,'') ReceivedDate
      ,[ReceivedBy]
      ,[SendDate]
      ,[SendBy]
      ,Isnull(TrackingNo,0) as TrackingNo
      ,[IDX]
      ,R.Status
  FROM [leg_Icon].[dbo].[tblInmateLegalRequest] R,
   [leg_Icon].[dbo].[tblInmate] I, [leg_Icon].[dbo].[tblFacility] F, [leg_Icon].[dbo].[tblTimeZone] T
   
				
WHERE I.FacilityId = R.FacilityID and I.InmateID = R.InmateID and
	R.FacilityID = F.FacilityID and F.timeZone = T.ZoneCode and
R.InmateID = @InmateID and R.FormID = @FormID AND  R.FacilityId = @FacilityId  and I.Status =1;
