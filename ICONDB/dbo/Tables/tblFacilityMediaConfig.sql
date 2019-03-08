CREATE TABLE [dbo].[tblFacilityMediaConfig] (
    [FacilityID]    INT          NOT NULL,
    [BookOpt]       BIT          NULL,
    [MovieOpt]      BIT          NULL,
    [MusicOpt]      BIT          NULL,
    [VocationalOpt] BIT          NULL,
    [EducationOpt]  BIT          NULL,
    [InputDate]     DATETIME     NULL,
    [ModifyDate]    DATETIME     NULL,
    [UserName]      VARCHAR (25) NULL,
    [sceneryOpt]    BIT          NULL,
    [ReligionOpt]   BIT          NULL,
    [SelfDevOpt]    BIT          NULL,
    [CampusLibOpt]  BIT          NULL,
    CONSTRAINT [PK_tblFacilityMediaConfig] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

