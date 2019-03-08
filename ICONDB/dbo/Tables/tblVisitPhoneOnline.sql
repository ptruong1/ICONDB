CREATE TABLE [dbo].[tblVisitPhoneOnline] (
    [FacilityID]  INT          NOT NULL,
    [Ext]         VARCHAR (10) NOT NULL,
    [PIN]         VARCHAR (12) NULL,
    [RecordDate]  DATETIME     NULL,
    [MaxDuration] SMALLINT     NULL,
    [RecordOpt]   CHAR (1)     NULL,
    [RecordID]    VARCHAR (25) NULL,
    CONSTRAINT [PK_tblVisitPhoneOnline] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [Ext] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblVisitPhoneOnline]
    ON [dbo].[tblVisitPhoneOnline]([FacilityID] ASC, [Ext] ASC, [RecordID] ASC);

