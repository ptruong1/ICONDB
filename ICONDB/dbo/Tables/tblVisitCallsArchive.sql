CREATE TABLE [dbo].[tblVisitCallsArchive] (
    [ExtID]         VARCHAR (15)   NULL,
    [PIN]           VARCHAR (12)   NULL,
    [FacilityID]    INT            NULL,
    [FolderDate]    CHAR (8)       NULL,
    [RecordDate]    DATETIME       NULL,
    [duration]      INT            NULL,
    [RateID]        VARCHAR (7)    NULL,
    [ConnectFee]    NUMERIC (4, 2) NULL,
    [MinuteCharge]  NUMERIC (4, 2) NULL,
    [CallRevenue]   NUMERIC (6, 2) NULL,
    [VisitType]     TINYINT        NULL,
    [VisitBilltype] TINYINT        NULL,
    [RecordName]    VARCHAR (25)   NULL,
    [CallTime]      VARCHAR (6)    NULL,
    [ServerIP]      VARCHAR (30)   NULL,
    [InmateID]      VARCHAR (12)   NULL
);

