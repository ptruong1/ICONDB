CREATE TABLE [dbo].[tblPurchaseDetail] (
    [PurchaseNo] BIGINT         NULL,
    [DetailCat]  TINYINT        NULL,
    [Detailtype] TINYINT        NULL,
    [Amount]     DECIMAL (6, 2) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_PO]
    ON [dbo].[tblPurchaseDetail]([PurchaseNo] ASC);

