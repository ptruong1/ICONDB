CREATE TABLE [dbo].[tblVisitPaid] (
    [ConfirmID]   INT            NOT NULL,
    [AccountNo]   VARCHAR (12)   NULL,
    [Amount]      NUMERIC (5, 2) NULL,
    [Status]      TINYINT        NULL,
    [ConfirmDate] DATETIME       NULL,
    [ModifyDate]  DATETIME       NULL,
    CONSTRAINT [PK_tblVisitPaid] PRIMARY KEY CLUSTERED ([ConfirmID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_visitpaid]
    ON [dbo].[tblVisitPaid]([AccountNo] ASC, [ConfirmDate] ASC);

