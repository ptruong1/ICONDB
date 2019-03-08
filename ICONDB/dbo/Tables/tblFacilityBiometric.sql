CREATE TABLE [dbo].[tblFacilityBiometric] (
    [FacilityID]              INT      NOT NULL,
    [Score]                   SMALLINT NULL,
    [VoiceITConfidentPercent] SMALLINT NULL,
    CONSTRAINT [PK_tblFacilityBiometric] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

