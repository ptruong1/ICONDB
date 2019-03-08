CREATE TABLE [dbo].[tblThirdPartyDectectRecord_OldbackUp] (
    [RecordID]             VARCHAR (12) NOT NULL,
    [FacilityID]           INT          NOT NULL,
    [FromNo]               VARCHAR (10) NULL,
    [ToNo]                 VARCHAR (18) NULL,
    [RecordDate]           DATETIME     NULL,
    [Duration]             INT          NULL,
    [CallType]             CHAR (2)     NULL,
    [BillType]             CHAR (2)     NULL,
    [DetectType]           TINYINT      NULL,
    [PIN]                  VARCHAR (12) NULL,
    [InmateId]             VARCHAR (12) NULL,
    [DetectTime]           DATETIME     NULL,
    [Score]                SMALLINT     NULL,
    [SuspiciousId]         VARCHAR (12) NULL,
    [Confidence]           VARCHAR (10) NULL,
    [InmateEnrolledSample] VARCHAR (50) NULL,
    [SuspiciousSample]     VARCHAR (75) NULL
);

