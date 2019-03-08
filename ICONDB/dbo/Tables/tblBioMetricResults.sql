CREATE TABLE [dbo].[tblBioMetricResults] (
    [facilityId]    SMALLINT      NOT NULL,
    [InmateID]      VARCHAR (12)  NOT NULL,
    [RecordID]      BIGINT        NOT NULL,
    [TransactionID] INT           NOT NULL,
    [SegmentNo]     INT           NULL,
    [BioStatus]     VARCHAR (20)  NULL,
    [BioScores]     INT           NULL,
    [BioUsableTime] INT           NULL,
    [VerifyStatus]  VARCHAR (1)   NULL,
    [InputDate]     DATETIME      NULL,
    [Note]          VARCHAR (150) NULL,
    [PIN]           VARCHAR (12)  NULL
);

