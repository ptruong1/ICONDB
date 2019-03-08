-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_FacilityOption_Record] 
	(
	@facilityID int
	)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT F.FacilityID
      ,isnull(AccuPIN,0) as AccuPIN
      ,isnull(BioMetric,0) as BioMetric
      ,isnull(AudioMining,0) as AudioMining
      ,isnull(FTPfolderName,'') as FTPfolderName
      ,isnull(SecretPin,0) as SecretPin
      ,isnull(inmateStatus,0) as inmateStatus
      ,isnull(AutoPin,0) as AutoPin
      ,isnull(NameRecord,0) as NameRecord
      ,isnull(VisitRegReq,0) as VisitRegReq
      ,isnull(VisitApmApprovedReq,0) as VisitApmApprovedReq
      ,isnull(Languages,'') as Languages
      ,isnull(FormsOpt,0) as FormsOpt
      ,isnull(SoftphoneOpt,0) as SoftphoneOpt
  FROM [leg_Icon].[dbo].[tblFacility] F
  Left Join
	 [leg_Icon].[dbo].[tblFacilityOption] O on F.FacilityID = O.FacilityID
	  where F.FacilityID = @facilityID
END

