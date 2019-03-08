CREATE TABLE [dbo].[tblPurchaseService] (
    [PurchaseNo]   BIGINT        NOT NULL,
    [AccountNo]    VARCHAR (50)  NULL,
    [PurchaseDate] SMALLDATETIME NULL,
    [ProcessedBy]  VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblPurchaseService] PRIMARY KEY CLUSTERED ([PurchaseNo] ASC)
);

