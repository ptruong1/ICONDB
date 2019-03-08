-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[p_Select_FacilityOption_Record] 
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
      ,isnull(VoiceMessageOpt,0) as VoiceMessageOpt
      ,isnull(EmailOpt,0) as EmailOpt
      ,isnull(InfoSysOpt,0) as InfoSysOpt
      ,isNull(AutoPAN,0) as AutoPAN
      ,isnull(VideoMessageOpt,0) as VideoMessageOpt
      ,isnull(PictureOpt,0) as PictureOpt
      ,isnull(LawLibOpt,0) as LawLibOpt
      ,isnull(VideoVisitOpt,0) as VideoVisitOpt
      ,ISNULL(Record2SideOpt,0) as Record2SideOpt
  FROM [leg_Icon].[dbo].[tblFacility] F
  Left Join
	 [leg_Icon].[dbo].[tblFacilityOption] O on F.FacilityID = O.FacilityID
	  where F.FacilityID = @facilityID
END

