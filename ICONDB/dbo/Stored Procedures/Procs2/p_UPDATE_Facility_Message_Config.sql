

CREATE PROCEDURE [dbo].[p_UPDATE_Facility_Message_Config]
(
	@facilityID int
      ,@VoiceLength tinyint
      ,@VoiceDirOpt tinyint
      ,@VoiceApvReq bit
      ,@EmailLength smallint
      ,@EmailDirOpt tinyint
      ,@EmailApvReq bit
      ,@VideoLength tinyint
      ,@VideoDirOpt tinyint
      ,@VideoApvReq bit
      ,@ImageSize tinyint
      ,@ImageDirOpt tinyint
      ,@ImageApvReq bit
      ,@TextLength tinyint
      ,@TextDirOpt smallint
      ,@TextApvReq bit
      ,@UserName varchar(25)
)
AS
	SET NOCOUNT OFF;
	UPDATE [leg_Icon].[dbo].[tblFacilityMessageConfig]
   SET [FacilityID] = @facilityID
      ,[VoiceLength] = @VoiceLength
      ,[VoiceDirOpt] = @VoiceDirOpt
      ,[VoiceApvReq] = @VoiceApvReq
      ,[EmailLength] = @EmailLength
      ,[EmailDirOpt] = @EmailDirOpt
      ,[EmailApvReq] = @EmailApvReq
      ,[VideoLength] = @VideoLength
      ,[VideoDirOpt] = @VideoDirOpt
      ,[VideoApvReq] = @VideoApvReq
      ,[ImageSize] = @ImageSize
      ,[ImageDirOpt] = @ImageDirOpt
      ,[ImageApvReq] = @ImageApvReq
      ,[TextLength] = @TextLength
      ,[TextDirOpt] = @TextDirOpt
      ,[TextApvReq] = @TextApvReq
      ,[ModifyDate] = GETDATE()
      ,[UserName] = @UserName
 WHERE facilityID = @facilityID

