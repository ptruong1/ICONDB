CREATE TABLE [dbo].[tblAnalyzedVoice] (
    [FacilityID]       INT          NOT NULL,
    [RecordID]         BIGINT       NOT NULL,
    [RecordInmateID]   VARCHAR (12) NULL,
    [SuspectInmateID1] VARCHAR (12) NULL,
    [SuspectInmateID2] VARCHAR (12) NULL,
    [SuspectInmateID3] VARCHAR (12) NULL,
    [AnalyzedDate]     DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_fac_rec]
    ON [dbo].[tblAnalyzedVoice]([FacilityID] ASC, [RecordID] ASC, [RecordInmateID] ASC);

