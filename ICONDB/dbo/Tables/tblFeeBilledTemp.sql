CREATE TABLE [dbo].[tblFeeBilledTemp] (
    [AccountNo]  VARCHAR (16)   NOT NULL,
    [FeeType]    TINYINT        NOT NULL,
    [Amount]     NUMERIC (4, 2) NOT NULL,
    [ChargeDate] CHAR (4)       NOT NULL,
    [RecordDate] DATETIME       NOT NULL,
    [RecordID]   BIGINT         NULL,
    [facilityID] INT            NULL
);

