CREATE TABLE [dbo].[tblDebitPaymentsArchive] (
    [paymentID]     BIGINT         NOT NULL,
    [AccountNo]     VARCHAR (12)   NULL,
    [InmateID]      VARCHAR (12)   NULL,
    [FacilityID]    INT            NULL,
    [Amount]        SMALLMONEY     NULL,
    [PaymentTypeID] TINYINT        NULL,
    [CheckNo]       INT            NULL,
    [CCNo]          VARCHAR (16)   NULL,
    [CCExp]         CHAR (4)       NULL,
    [CCzip]         CHAR (5)       NULL,
    [CCcode]        VARCHAR (4)    NULL,
    [UserName]      VARCHAR (25)   NULL,
    [CCFirstName]   VARCHAR (25)   NULL,
    [CCLastName]    VARCHAR (25)   NULL,
    [PaymentDate]   SMALLDATETIME  NULL,
    [Note]          VARCHAR (50)   NULL,
    [PurchaseNo]    BIGINT         NULL,
    [LastBalance]   NUMERIC (6, 2) NULL
);

