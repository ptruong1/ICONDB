CREATE TABLE [dbo].[tblTaxTypes] (
    [TaxTypeID]   INT           NOT NULL,
    [TaxTypeName] NVARCHAR (32) NULL,
    CONSTRAINT [PK_tblTaxTypes] PRIMARY KEY CLUSTERED ([TaxTypeID] ASC)
);

