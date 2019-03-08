CREATE TABLE [dbo].[tblTaxesRefund] (
    [RefundID]           INT            NOT NULL,
    [BillToNo]           VARCHAR (12)   NOT NULL,
    [BillType]           VARCHAR (2)    NOT NULL,
    [RefundAmount]       NUMERIC (6, 2) NOT NULL,
    [FedTaxRef]          NUMERIC (4, 2) NULL,
    [StateTaxRef]        NUMERIC (4, 2) NULL,
    [LocalTaxRef]        NUMERIC (4, 2) NULL,
    [RefundDate]         DATETIME       NULL,
    [UserName]           VARCHAR (25)   NULL,
    [State]              VARCHAR (2)    NULL,
    [StateAccountNameID] TINYINT        NULL,
    [LocalAccountNameID] TINYINT        NULL,
    [TaxCategoryID]      TINYINT        NULL,
    [CallType]           VARCHAR (2)    NULL,
    CONSTRAINT [PK_tblTaxesRefund] PRIMARY KEY CLUSTERED ([RefundID] ASC)
);

