CREATE TABLE [dbo].[tblMailboxDetail] (
    [MailBoxID]       BIGINT         NOT NULL,
    [MessageID]       BIGINT         NOT NULL,
    [MessageTypeID]   TINYINT        CONSTRAINT [DF_tblMailboxDetail_MessageTypeID] DEFAULT ((1)) NULL,
    [MessengerNo]     CHAR (10)      NULL,
    [MessageDate]     DATETIME       NULL,
    [MessageName]     VARCHAR (50)   NULL,
    [IsNew]           BIT            NULL,
    [FolderDate]      CHAR (8)       NULL,
    [Message]         VARCHAR (4000) NULL,
    [SenderMailBoxID] INT            NULL,
    [CCEmails]        VARCHAR (200)  NULL,
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
    [DeviceName]      VARCHAR (20)   NULL,
    CONSTRAINT [PK_tblMailboxDetail] PRIMARY KEY CLUSTERED ([MailBoxID] ASC, [MessageID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ind_message]
    ON [dbo].[tblMailboxDetail]([MailBoxID] ASC, [IsNew] ASC);

