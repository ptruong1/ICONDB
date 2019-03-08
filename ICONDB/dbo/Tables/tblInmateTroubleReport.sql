CREATE TABLE [dbo].[tblInmateTroubleReport] (
    [RecordID]   INT          NOT NULL,
    [FacilityID] INT          NOT NULL,
    [PIN]        VARCHAR (12) NOT NULL,
    [RecordDate] DATETIME     NOT NULL,
    [RecordName] VARCHAR (20) NOT NULL
);

