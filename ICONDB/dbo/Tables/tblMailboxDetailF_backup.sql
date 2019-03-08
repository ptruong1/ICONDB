CREATE TABLE [dbo].[tblMailboxDetailF_backup] (
    [MailBoxID]       BIGINT          NOT NULL,
    [MessageID]       BIGINT          NOT NULL,
    [MessageTypeID]   TINYINT         NULL,
    [MessageDate]     DATETIME        NULL,
    [MessageName]     VARCHAR (50)    NULL,
    [IsNew]           BIT             NULL,
    [FolderDate]      CHAR (8)        NULL,
    [Message]         NVARCHAR (2500) NULL,
    [SenderMailBoxID] INT             NULL,
    [Email]           VARCHAR (70)    NULL,
    [IsReply]         BIT             NULL,
    [MessageStatus]   TINYINT         NULL,
    [ReviewNote]      VARCHAR (150)   NULL,
    [Charge]          SMALLMONEY      NULL,
    [readCount]       SMALLINT        NULL,
    [ApprovedBy]      VARCHAR (25)    NULL,
    [ApprovedDate]    DATETIME        NULL,
    [DeniedDate]      DATETIME        NULL,
    [DeniedBy]        VARCHAR (25)    NULL,
    [VideoStatus]     TINYINT         NULL
);

