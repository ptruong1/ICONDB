CREATE TABLE [dbo].[tblCallsUnbilledArchive] (
    [calldate]     CHAR (6)      NULL,
    [projectcode]  CHAR (6)      NULL,
    [calltime]     CHAR (6)      NULL,
    [fromno]       CHAR (10)     NULL,
    [tono]         VARCHAR (16)  NULL,
    [billtype]     CHAR (2)      NULL,
    [errorType]    TINYINT       NULL,
    [RecordDate]   SMALLDATETIME NULL,
    [InmateID]     VARCHAR (12)  NULL,
    [PIN]          VARCHAR (12)  NULL,
    [FacilityID]   INT           NULL,
    [HostName]     VARCHAR (16)  NULL,
    [ResponseCode] VARCHAR (3)   NULL,
    [OpseqNo]      VARCHAR (6)   NULL,
    [InRecordFile] VARCHAR (20)  NULL,
    [DebitCardNo]  VARCHAR (12)  NULL,
    [PhoneType]    TINYINT       NULL,
    [Calltype]     VARCHAR (2)   NULL,
    [RecordID]     BIGINT        NULL,
    [OutDuration]  SMALLINT      NULL,
    [UserLanguage] TINYINT       NULL
);

