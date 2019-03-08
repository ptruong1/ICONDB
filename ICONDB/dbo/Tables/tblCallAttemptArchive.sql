CREATE TABLE [dbo].[tblCallAttemptArchive] (
    [OpSeqNo]    BIGINT       NOT NULL,
    [FromNo]     CHAR (10)    NULL,
    [DialedNo]   VARCHAR (10) NULL,
    [FacilityID] INT          NULL,
    [AgentID]    INT          NULL,
    [RecordDate] DATETIME     NOT NULL
);

