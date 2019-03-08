CREATE TABLE [dbo].[tblTaxesBilled] (
    [ReferenceNo]   BIGINT         NOT NULL,
    [BillType]      VARCHAR (2)    NULL,
    [FedTax]        NUMERIC (4, 2) NULL,
    [StateTax]      NUMERIC (4, 2) NULL,
    [LocalTax]      NUMERIC (4, 2) NULL,
    [BilledDate]    DATETIME       NULL,
    [BilledStatus]  TINYINT        NULL,
    [BillToNo]      VARCHAR (12)   NULL,
    [BilledRevenue] NUMERIC (6, 2) NULL,
    [State]         VARCHAR (2)    NULL,
    [taxID]         INT            NULL,
    [CallType]      VARCHAR (2)    NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-reference No]
    ON [dbo].[tblTaxesBilled]([ReferenceNo] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-ChargeDate-TaxType]
    ON [dbo].[tblTaxesBilled]([FedTax] ASC, [StateTax] ASC, [LocalTax] ASC, [BilledDate] ASC);

