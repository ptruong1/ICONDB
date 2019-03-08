CREATE TABLE [dbo].[tblDebitCardOrderDup] (
    [OrderNo]    VARCHAR (22)   NULL,
    [FacilityID] INT            NOT NULL,
    [InmateID]   VARCHAR (12)   NOT NULL,
    [OrderDate]  DATETIME       CONSTRAINT [DF_tblDebitCardOrderDup_OrderDate] DEFAULT (getdate()) NOT NULL,
    [Amount]     NUMERIC (6, 2) NOT NULL,
    [clientID]   VARCHAR (10)   NULL
);

