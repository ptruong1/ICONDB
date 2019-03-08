CREATE TABLE [dbo].[tblVisitCalls] (
    [ExtID]         VARCHAR (15)   NOT NULL,
    [PIN]           VARCHAR (12)   NULL,
    [FacilityID]    INT            NOT NULL,
    [FolderDate]    CHAR (8)       NULL,
    [RecordDate]    DATETIME       NOT NULL,
    [duration]      INT            NULL,
    [RateID]        VARCHAR (7)    NULL,
    [ConnectFee]    NUMERIC (4, 2) NULL,
    [MinuteCharge]  NUMERIC (4, 2) NULL,
    [CallRevenue]   NUMERIC (6, 2) NULL,
    [VisitType]     TINYINT        NULL,
    [VisitBilltype] TINYINT        NULL,
    [RecordName]    VARCHAR (25)   NOT NULL,
    [CallTime]      VARCHAR (6)    NULL,
    [ServerIP]      VARCHAR (30)   NULL,
    [InmateID]      VARCHAR (12)   NULL,
    CONSTRAINT [PK_tblVisitCalls] PRIMARY KEY CLUSTERED ([ExtID] ASC, [FacilityID] ASC, [RecordDate] ASC, [RecordName] ASC)
);

