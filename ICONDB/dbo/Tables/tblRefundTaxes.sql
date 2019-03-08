CREATE TABLE [dbo].[tblRefundTaxes] (
    [BillToNo]     VARCHAR (12)   NOT NULL,
    [RefundAmount] NUMERIC (5, 2) NOT NULL,
    [RefundTax]    NUMERIC (5, 2) NOT NULL,
    [RefundDate]   DATETIME       NOT NULL,
    [RefundMethod] TINYINT        NOT NULL,
    [UserName]     VARCHAR (20)   NOT NULL
);

