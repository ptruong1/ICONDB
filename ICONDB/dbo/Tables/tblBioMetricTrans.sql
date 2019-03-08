CREATE TABLE [dbo].[tblBioMetricTrans] (
    [UserID]     VARCHAR (16) NOT NULL,
    [Results]    VARCHAR (50) NULL,
    [RecordDate] DATETIME     NULL,
    [transType]  TINYINT      NULL,
    [FacilityID] INT          NULL,
    [PIN]        VARCHAR (12) NULL,
    [TransID]    VARCHAR (16) NULL
);

