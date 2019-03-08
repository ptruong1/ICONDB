CREATE TABLE [dbo].[tblLibReply] (
    [PhoneNo]    CHAR (10)     NOT NULL,
    [ReplyCode]  CHAR (3)      NULL,
    [PhoneCat]   VARCHAR (10)  NULL,
    [OCN]        VARCHAR (4)   NULL,
    [InputDate]  SMALLDATETIME CONSTRAINT [DF_tblLibReply_InputDate] DEFAULT (getdate()) NULL,
    [ModifyDate] SMALLDATETIME NULL,
    CONSTRAINT [PK_tblLibReply] PRIMARY KEY CLUSTERED ([PhoneNo] ASC)
);

