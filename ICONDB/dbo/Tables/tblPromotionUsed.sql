CREATE TABLE [dbo].[tblPromotionUsed] (
    [AccountNo]       VARCHAR (12) NULL,
    [PromoteCodeUsed] VARCHAR (10) NULL,
    [UsedDate]        DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_Acct_code]
    ON [dbo].[tblPromotionUsed]([AccountNo] ASC, [PromoteCodeUsed] ASC);

