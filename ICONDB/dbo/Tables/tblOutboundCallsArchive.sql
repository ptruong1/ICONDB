CREATE TABLE [dbo].[tblOutboundCallsArchive] (
    [OpSeqNo]        BIGINT       NULL,
    [calldate]       CHAR (6)     NULL,
    [calltime]       CHAR (6)     NULL,
    [projectCode]    CHAR (6)     NULL,
    [fromno]         CHAR (10)    NULL,
    [tono]           VARCHAR (18) NULL,
    [billtype]       CHAR (2)     NULL,
    [recordDate]     DATETIME     NULL,
    [Duration]       INT          NULL,
    [DisconnectType] TINYINT      NULL
);

