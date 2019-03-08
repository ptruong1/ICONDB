CREATE TABLE [dbo].[tblOutboundCalls] (
    [OpSeqNo]        BIGINT       NULL,
    [calldate]       CHAR (6)     NULL,
    [calltime]       CHAR (6)     NULL,
    [projectCode]    CHAR (6)     NULL,
    [fromno]         CHAR (10)    NULL,
    [tono]           VARCHAR (18) NULL,
    [billtype]       CHAR (2)     NULL,
    [recordDate]     DATETIME     CONSTRAINT [DF_tblOutboundCalls_recordDate] DEFAULT (getdate()) NULL,
    [Duration]       INT          NULL,
    [DisconnectType] TINYINT      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_OpseqNo]
    ON [dbo].[tblOutboundCalls]([OpSeqNo] ASC, [calldate] ASC, [recordDate] ASC, [Duration] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_recorddate]
    ON [dbo].[tblOutboundCalls]([recordDate] ASC);

