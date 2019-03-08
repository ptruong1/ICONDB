CREATE TABLE [dbo].[tblMailboxDetailF] (
    [MailBoxID]       BIGINT         NOT NULL,
    [MessageID]       BIGINT         NOT NULL,
    [MessageTypeID]   TINYINT        CONSTRAINT [DF_tblMailboxDetailF_MessageTypeID] DEFAULT ((1)) NULL,
    [MessageDate]     DATETIME       NULL,
    [MessageName]     VARCHAR (50)   NULL,
    [IsNew]           BIT            NULL,
    [FolderDate]      CHAR (8)       NULL,
    [Message]         VARCHAR (4000) NULL,
    [SenderMailBoxID] INT            NULL,
    [Email]           VARCHAR (70)   NULL,
    [IsReply]         BIT            NULL,
    [MessageStatus]   TINYINT        DEFAULT ((1)) NULL,
    [ReviewNote]      VARCHAR (150)  NULL,
    [Charge]          SMALLMONEY     NULL,
    [readCount]       SMALLINT       DEFAULT ((0)) NULL,
    [ApprovedBy]      VARCHAR (25)   NULL,
    [ApprovedDate]    DATETIME       NULL,
    [DeniedDate]      DATETIME       NULL,
    [DeniedBy]        VARCHAR (25)   NULL,
    [VideoStatus]     TINYINT        DEFAULT ((1)) NULL,
    [MonitorOpt]      CHAR (1)       DEFAULT ('Y') NULL,
    [DeviceName]      VARCHAR (20)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_tblMailboxDetailF_MessageStatus]
    ON [dbo].[tblMailboxDetailF]([MessageStatus] ASC)
    INCLUDE([MessageTypeID], [SenderMailBoxID], [VideoStatus]);

