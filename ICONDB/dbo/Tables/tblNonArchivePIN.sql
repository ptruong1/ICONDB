CREATE TABLE [dbo].[tblNonArchivePIN] (
    [FacilityID] INT           NOT NULL,
    [PIN]        VARCHAR (12)  NOT NULL,
    [InputDate]  SMALLDATETIME NULL,
    [Username]   VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblNonArchivePIN] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [PIN] ASC)
);

