CREATE TABLE [dbo].[tblCustomReport] (
    [UserID]     VARCHAR (20)   NOT NULL,
    [Title]      VARCHAR (100)  NOT NULL,
    [URL]        VARCHAR (1000) NULL,
    [InputDate]  SMALLDATETIME  NULL,
    [ModifyDate] SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblCustomReport] PRIMARY KEY CLUSTERED ([UserID] ASC, [Title] ASC)
);

