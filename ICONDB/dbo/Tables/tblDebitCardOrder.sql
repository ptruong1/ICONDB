CREATE TABLE [dbo].[tblDebitCardOrder] (
    [OrderNo]    VARCHAR (22)   NULL,
    [FacilityID] INT            NOT NULL,
    [InmateID]   VARCHAR (12)   NOT NULL,
    [OrderDate]  DATETIME       CONSTRAINT [DF_tblDebitCardOrder_OrderDate] DEFAULT (getdate()) NOT NULL,
    [Amount]     NUMERIC (6, 2) NOT NULL,
    [clientID]   VARCHAR (20)   NULL
);

