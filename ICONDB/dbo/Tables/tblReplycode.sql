CREATE TABLE [dbo].[tblReplycode] (
    [replycode]   CHAR (3)     NOT NULL,
    [billable]    CHAR (1)     NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblReplycode] PRIMARY KEY CLUSTERED ([replycode] ASC)
);

