CREATE TABLE [dbo].[ ] (
    [RecordID]       VARCHAR (34) NULL,
    [InmateID]       VARCHAR (12) NULL,
    [InmateName]     VARCHAR (50) NOT NULL,
    [ActivityDate]   DATETIME     NULL,
    [ActivityType]   VARCHAR (20) NULL,
    [StationID]      VARCHAR (25) NOT NULL,
    [ContactPhone]   VARCHAR (18) NULL,
    [ContactName]    VARCHAR (50) NOT NULL,
    [Duration]       VARCHAR (8)  NULL,
    [ActivityStatus] VARCHAR (25) NULL,
    [Phonetype]      VARCHAR (15) NULL,
    [RecordOpt]      VARCHAR (1)  NULL,
    [RowNum]         BIGINT       NULL
);

