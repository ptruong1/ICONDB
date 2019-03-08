CREATE TABLE [dbo].[tblThirdPartyDectectRecord_backUp] (
    [RecordID]   VARCHAR (12) NOT NULL,
    [FacilityID] INT          NOT NULL,
    [FromNo]     VARCHAR (10) NULL,
    [ToNo]       VARCHAR (18) NULL,
    [RecodDate]  DATETIME     NULL,
    [Duration]   INT          NULL,
    [CallType]   CHAR (2)     NULL,
    [BillType]   CHAR (2)     NULL,
    [DetectType] TINYINT      NULL,
    [PIN]        VARCHAR (10) NULL,
    [DetectTime] DATETIME     NULL,
    [Score]      SMALLINT     NULL,
    [Confidence] VARCHAR (10) NULL
);

