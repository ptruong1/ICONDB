CREATE TABLE [dbo].[tblDebitCardOrderArchive] (
    [OrderNo]    VARCHAR (22)   NULL,
    [FacilityID] INT            NOT NULL,
    [InmateID]   VARCHAR (12)   NOT NULL,
    [OrderDate]  DATETIME       CONSTRAINT [DF_tblDebitCardOrder_OrderDateArchive] DEFAULT (getdate()) NOT NULL,
    [Amount]     NUMERIC (6, 2) NOT NULL,
    [clientID]   VARCHAR (20)   NULL
);

