CREATE TABLE [dbo].[tblFacilityLanguages] (
    [FacilityID]    INT      NOT NULL,
    [LanguageOrder] TINYINT  NOT NULL,
    [LanguageID]    SMALLINT NOT NULL,
    CONSTRAINT [PK_tblFacilityLanguages] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [LanguageOrder] ASC)
);

