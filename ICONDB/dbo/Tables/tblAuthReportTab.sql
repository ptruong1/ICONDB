CREATE TABLE [dbo].[tblAuthReportTab] (
    [AuthID]        BIGINT NOT NULL,
    [Report]        BIT    CONSTRAINT [DF_tblAuthReportTab_Report] DEFAULT ((1)) NULL,
    [CDR]           BIT    CONSTRAINT [DF_tblAuthReportTab_CDR] DEFAULT ((1)) NULL,
    [CustomReports] BIT    NULL,
    [DataLink]      BIT    NULL,
    CONSTRAINT [PK_tblAuthReportTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

