CREATE TABLE [dbo].[tblBioMetricIdentification] (
    [UserID]     VARCHAR (16) NOT NULL,
    [TransID]    VARCHAR (16) NULL,
    [transType]  TINYINT      NULL,
    [Results]    VARCHAR (50) NULL,
    [RecordDate] DATETIME     NULL,
    [PIN]        VARCHAR (12) NULL,
    [Note]       NCHAR (150)  NULL
);

