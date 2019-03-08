CREATE TABLE [dbo].[tblPrepaidPayments] (
    [paymentID]     BIGINT         NOT NULL,
    [AccountNo]     VARCHAR (12)   NULL,
    [InmateID]      INT            NULL,
    [FacilityID]    INT            NULL,
    [Amount]        SMALLMONEY     NULL,
    [PaymentTypeID] TINYINT        NULL,
    [CheckNo]       INT            NULL,
    [CCNo]          VARCHAR (16)   NULL,
    [CCExp]         CHAR (4)       NULL,
    [CCzip]         CHAR (5)       NULL,
    [CCcode]        VARCHAR (4)    NULL,
    [CCFirstName]   VARCHAR (25)   NULL,
    [CCLastName]    VARCHAR (25)   NULL,
    [UserName]      VARCHAR (25)   NULL,
    [PaymentDate]   DATETIME       NULL,
    [Note]          VARCHAR (150)  NULL,
    [PurchaseNo]    BIGINT         NULL,
    [LastBalance]   NUMERIC (7, 2) NULL,
    CONSTRAINT [PK_tblPrepaidPayments] PRIMARY KEY CLUSTERED ([paymentID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_purchaseNo]
    ON [dbo].[tblPrepaidPayments]([AccountNo] ASC, [PurchaseNo] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_ccno]
    ON [dbo].[tblPrepaidPayments]([CCNo] ASC, [PaymentDate] ASC);

