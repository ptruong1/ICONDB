CREATE TABLE [dbo].[tblTaxes] (
    [TaxID]              INT           NOT NULL,
    [State]              NVARCHAR (2)  NULL,
    [TaxingJurisName]    NVARCHAR (50) NULL,
    [TaxTypeID]          INT           NULL,
    [Rate]               FLOAT (53)    NULL,
    [Amount]             MONEY         NULL,
    [StartDate]          DATETIME      NULL,
    [EndDate]            DATETIME      NULL,
    [LastUpdated]        DATETIME      NULL,
    [TaxOnUsage]         INT           NULL,
    [TaxOnProduct]       INT           NULL,
    [TaxCategoryID]      INT           NULL,
    [TaxOnIntrastate]    BIT           NULL,
    [TaxOnInterstate]    BIT           NULL,
    [TaxOnInternational] BIT           NULL,
    [UserID]             NVARCHAR (32) NULL,
    CONSTRAINT [PK_Taxes1] PRIMARY KEY CLUSTERED ([TaxID] ASC)
);

