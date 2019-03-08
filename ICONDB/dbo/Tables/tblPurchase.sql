CREATE TABLE [dbo].[tblPurchase] (
    [PurchaseNo]   BIGINT        NOT NULL,
    [AccountNo]    VARCHAR (50)  NULL,
    [PurchaseDate] SMALLDATETIME NULL,
    [ProcessedBy]  VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblPurchase1] PRIMARY KEY CLUSTERED ([PurchaseNo] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_acct]
    ON [dbo].[tblPurchase]([AccountNo] ASC);

