CREATE TABLE [dbo].[tblIncidentReport] (
    [IncidentID]   INT          NOT NULL,
    [ANI]          CHAR (10)    NOT NULL,
    [FacilityID]   INT          NULL,
    [InmateID]     VARCHAR (12) NULL,
    [PIN]          VARCHAR (12) NULL,
    [ReportTime]   DATETIME     CONSTRAINT [DF_tblIncidentReport_ReportTime] DEFAULT (getdate()) NULL,
    [Channel]      TINYINT      NULL,
    [FolderName]   CHAR (8)     NULL,
    [FileName]     VARCHAR (18) NULL,
    [DBerror]      CHAR (1)     NULL,
    [InputDate]    DATETIME     CONSTRAINT [DF_tblIncidentReport_InputDate] DEFAULT (getdate()) NULL,
    [ServerIP]     VARCHAR (17) NULL,
    [IncidentType] TINYINT      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_record]
    ON [dbo].[tblIncidentReport]([ANI] ASC, [PIN] ASC, [InputDate] ASC);

