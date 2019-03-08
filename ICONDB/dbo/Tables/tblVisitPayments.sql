CREATE TABLE [dbo].[tblVisitPayments] (
    [paymentID]     BIGINT        NOT NULL,
    [AccountNo]     VARCHAR (12)  NULL,
    [InmateID]      VARCHAR (12)  NULL,
    [FacilityID]    INT           NULL,
    [Amount]        SMALLMONEY    NULL,
    [PaymentTypeID] TINYINT       NULL,
    [CheckNo]       INT           NULL,
    [CCNo]          VARCHAR (16)  NULL,
    [CCExp]         CHAR (4)      NULL,
    [CCzip]         CHAR (5)      NULL,
    [CCcode]        VARCHAR (4)   NULL,
    [CCFirstName]   VARCHAR (25)  NULL,
    [CCLastName]    VARCHAR (25)  NULL,
    [UserName]      VARCHAR (25)  NULL,
    [PaymentDate]   DATETIME      NULL,
    [Note]          VARCHAR (150) NULL,
    [PurchaseNo]    INT           NULL
);

