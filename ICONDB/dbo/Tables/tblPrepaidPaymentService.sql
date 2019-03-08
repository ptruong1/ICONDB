CREATE TABLE [dbo].[tblPrepaidPaymentService] (
    [paymentID]     BIGINT         NOT NULL,
    [AccountNo]     VARCHAR (12)   NULL,
    [FacilityID]    INT            NULL,
    [SetupFee]      NUMERIC (6, 2) NULL,
    [ProcessFee]    NUMERIC (6, 2) NULL,
    [Tax]           NUMERIC (6, 2) NULL,
    [Amount]        SMALLMONEY     NULL,
    [PaymentTypeID] TINYINT        NULL,
    [CheckNo]       INT            NULL,
    [CCNo]          VARCHAR (16)   NULL,
    [CCExp]         CHAR (4)       NULL,
    [CCAddress]     VARCHAR (50)   NULL,
    [CCzip]         CHAR (5)       NULL,
    [CCcode]        VARCHAR (4)    NULL,
    [CCFirstName]   VARCHAR (25)   NULL,
    [CCLastName]    VARCHAR (25)   NULL,
    [UserName]      VARCHAR (25)   NULL,
    [PaymentDate]   DATETIME       NULL,
    [Note]          VARCHAR (50)   NULL,
    [PurchaseNo]    INT            NULL,
    [status]        BIT            NULL
);

