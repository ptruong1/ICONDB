CREATE TABLE [dbo].[tblKeefeTransactionLog] (
    [TransactionId]   VARCHAR (40)   NOT NULL,
    [FacilityID]      INT            NOT NULL,
    [InmateID]        VARCHAR (12)   NOT NULL,
    [TransactionDate] DATETIME       NOT NULL,
    [Amount]          NUMERIC (6, 2) NOT NULL,
    [clientID]        VARCHAR (20)   NULL,
    [InputDate]       DATETIME       NOT NULL,
    [ConfirmDate]     VARCHAR (50)   NULL,
    CONSTRAINT [PK_tblKeefeTransactionLog] PRIMARY KEY CLUSTERED ([TransactionId] ASC)
);

