CREATE TABLE [dbo].[tblCDR] (
    [FacilityName]  VARCHAR (70)   NULL,
    [FacilityID]    INT            NULL,
    [FromNo]        VARCHAR (10)   NULL,
    [toNo]          VARCHAR (16)   NULL,
    [RecordID]      BIGINT         NULL,
    [FromCity]      VARCHAR (20)   NULL,
    [FromState]     VARCHAR (2)    NULL,
    [ToCity]        VARCHAR (20)   NULL,
    [ToState]       VARCHAR (2)    NULL,
    [StationID]     VARCHAR (20)   NULL,
    [LocationName]  VARCHAR (25)   NULL,
    [InmateID]      VARCHAR (12)   NULL,
    [PIN]           VARCHAR (12)   NULL,
    [CallingCard]   VARCHAR (12)   NULL,
    [RevenuePeriod] VARCHAR (4)    NULL,
    [CallStart]     DATETIME       NULL,
    [CallEnd]       DATETIME       NULL,
    [Duration]      INT            NULL,
    [BillType]      VARCHAR (25)   NULL,
    [CallType]      VARCHAR (25)   NULL,
    [CallRevenue]   NUMERIC (5, 2) NULL,
    [Tax]           NUMERIC (5, 2) NULL,
    [Validation]    VARCHAR (20)   NULL,
    [ErrorCode]     VARCHAR (25)   NULL,
    [LIDBcode]      VARCHAR (10)   NULL,
    [Complete]      CHAR (1)       NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_RevPeriod]
    ON [dbo].[tblCDR]([RevenuePeriod] ASC);

