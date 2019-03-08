CREATE TABLE [dbo].[tblCallAttempt] (
    [OpSeqNo]    BIGINT       NOT NULL,
    [FromNo]     CHAR (10)    NULL,
    [DialedNo]   VARCHAR (10) NULL,
    [FacilityID] INT          NULL,
    [AgentID]    INT          NULL,
    [RecordDate] DATETIME     CONSTRAINT [DF_tblAttempt_RecordDate] DEFAULT (getdate()) NOT NULL
);

