CREATE TABLE [dbo].[tblCustomReport2] (
    [UserID]     VARCHAR (20)   NOT NULL,
    [Title]      VARCHAR (100)  NOT NULL,
    [URL]        VARCHAR (1000) NULL,
    [InputDate]  SMALLDATETIME  NULL,
    [ModifyDate] SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblCustomReport_test] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblCustomReport_test]
    ON [dbo].[tblCustomReport2]([UserID] ASC);

