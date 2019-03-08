CREATE TABLE [dbo].[tblPurchase2] (
    [PurchaseNo]   BIGINT        NOT NULL,
    [AccountNo]    VARCHAR (50)  NULL,
    [PurchaseDate] SMALLDATETIME NULL,
    [ProcessedBy]  VARCHAR (20)  NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_ACCT]
    ON [dbo].[tblPurchase2]([AccountNo] ASC);

