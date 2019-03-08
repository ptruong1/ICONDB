

CREATE PROCEDURE [dbo].[p_Insert_Facility_Message_Config]
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
INSERT INTO [leg_Icon].[dbo].[tblFacilityMessageConfig]
           ([FacilityID]
           ,[VoiceLength]
           ,[VoiceDirOpt]
           ,[VoiceApvReq]
           ,[EmailLength]
           ,[EmailDirOpt]
           ,[EmailApvReq]
           ,[VideoLength]
           ,[VideoDirOpt]
           ,[VideoApvReq]
           ,[ImageSize]
           ,[ImageDirOpt]
           ,[ImageApvReq]
           ,[TextLength]
           ,[TextDirOpt]
           ,[TextApvReq]
           ,[InputDate]
           ,[UserName])
     VALUES
           (@FacilityID
           ,@VoiceLength
           ,@VoiceDirOpt
           ,@VoiceApvReq
           ,@EmailLength
           ,@EmailDirOpt
           ,@EmailApvReq
           ,@VideoLength
           ,@VideoDirOpt
           ,@VideoApvReq
           ,@ImageSize
           ,@ImageDirOpt
           ,@ImageApvReq
           ,@TextLength
           ,@TextDirOpt
           ,@TextApvReq
           ,GETDATE()
           ,@UserName)

