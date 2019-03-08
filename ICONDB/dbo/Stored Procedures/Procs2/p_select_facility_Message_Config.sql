-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_facility_Message_Config]
(
@FacilityID int
)
AS
BEGIN
	SELECT [FacilityID]
      ,isnull(VoiceLength,0) as VoiceLength
      ,D.Descript as VoiceDirOpt
      ,isnull(VoiceDirOpt,10) as VoiceOpt
      ,isnull(VoiceApvReq,0) as VoiceApvReq
      ,isnull(EmailLength,0) as EmailLength
      ,C.Descript as EmailDirOpt
      ,isnull(EmailDirOpt,10) as EmailOpt
      ,isnull(EmailApvReq,0) as EmailApvReq
      ,isnull(VideoLength,0) as VideoLength
      ,E.Descript as VideoDirOpt
      ,isnull(VideoDirOpt,10) as VideoOpt
      ,isnull(VideoApvReq,0) as VideoApvReq
      ,isnull(ImageSize,0) as ImageSize
      ,F.Descript as ImageDirOpt
      ,isnull(ImageDirOpt,10) as ImageOpt
      ,isnull(ImageApvReq,0) as ImageApvReq
      ,isnull(TextLength,0) as TextLength
      ,G.Descript as TextDirOpt
      ,isnull(TextDirOpt,10) as TextOpt
      ,isnull(TextApvReq,0) as TextApvReq
      
      
  FROM [leg_Icon].[dbo].[tblFacilityMessageConfig] 
  left join [leg_Icon].[dbo].[tblMessageDirOption] D on isnull(VoiceDirOpt,10) = D.MessageDirOpt
  left join [leg_Icon].[dbo].[tblMessageDirOption] C on isnull(EmailDirOpt,10) = C.MessageDirOpt
   left join [leg_Icon].[dbo].[tblMessageDirOption] E on isnull(VideoDirOpt,10) = E.MessageDirOpt
   left join [leg_Icon].[dbo].[tblMessageDirOption] F on isnull(ImageDirOpt,10) = F.MessageDirOpt
   left join [leg_Icon].[dbo].[tblMessageDirOption] G on isnull(TextDirOpt,10) = G.MessageDirOpt
   where
   FacilityID = @FacilityID
   
End
