CREATE TABLE [dbo].[tblFacilityMessageConfig] (
    [FacilityID]  INT          NOT NULL,
    [VoiceLength] TINYINT      NULL,
    [VoiceDirOpt] TINYINT      NULL,
    [VoiceApvReq] BIT          NULL,
    [EmailLength] SMALLINT     NULL,
    [EmailDirOpt] TINYINT      NULL,
    [EmailApvReq] BIT          NULL,
    [VideoLength] TINYINT      NULL,
    [VideoDirOpt] TINYINT      NULL,
    [VideoApvReq] BIT          NULL,
    [ImageSize]   TINYINT      NULL,
    [ImageDirOpt] TINYINT      NULL,
    [ImageApvReq] BIT          NULL,
    [TextLength]  TINYINT      NULL,
    [TextDirOpt]  SMALLINT     NULL,
    [TextApvReq]  BIT          NULL,
    [InputDate]   DATETIME     NULL,
    [ModifyDate]  DATE         NULL,
    [UserName]    VARCHAR (25) NULL,
    [MonOpt]      CHAR (1)     DEFAULT ('Y') NULL,
    CONSTRAINT [PK_tblFacilityMessageConfig] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

