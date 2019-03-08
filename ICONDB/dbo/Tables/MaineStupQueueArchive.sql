CREATE TABLE [dbo].[MaineStupQueueArchive] (
    [APIType]     TINYINT      NOT NULL,
    [RecordDate]  DATETIME     NOT NULL,
    [PIN]         VARCHAR (12) NULL,
    [InmateID]    VARCHAR (12) NULL,
    [FromNo]      VARCHAR (10) NULL,
    [ToNo]        VARCHAR (10) NULL,
    [ReferenceNo] BIGINT       NULL,
    [Duration]    SMALLINT     NULL,
    [Charge]      SMALLMONEY   NULL,
    [Qout]        BIT          NULL
);

