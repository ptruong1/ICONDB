CREATE TABLE [dbo].[tblFacilityPasswordPolicy] (
    [PolicyID]       INT          NOT NULL,
    [FacilityID]     INT          NOT NULL,
    [PasswordLength] TINYINT      NOT NULL,
    [CapLeter]       BIT          NULL,
    [SpecialChar]    BIT          NULL,
    [NumberChar]     BIT          NULL,
    [ExperiredDays]  SMALLINT     NULL,
    [CreatedDate]    DATETIME     NULL,
    [ModifiedDate]   DATETIME     NULL,
    [CreatedBy]      VARCHAR (25) NULL,
    CONSTRAINT [PK_tblFacilityPasswordPolicy] PRIMARY KEY CLUSTERED ([PolicyID] ASC, [FacilityID] ASC)
);

