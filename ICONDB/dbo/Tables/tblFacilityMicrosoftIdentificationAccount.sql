CREATE TABLE [dbo].[tblFacilityMicrosoftIdentificationAccount] (
    [FacilityID]              BIGINT       NOT NULL,
    [Email]                   VARCHAR (50) NOT NULL,
    [MicrosoftPassword]       VARCHAR (12) NULL,
    [IdentificationPrimeKey]  VARCHAR (50) NULL,
    [IdentificationSecondKey] VARCHAR (50) NULL,
    [InputDate]               DATETIME     CONSTRAINT [DF_tblFacilityMicrosoftIdentificationAccount_InputDate] DEFAULT (getdate()) NULL,
    [DivID]                   BIGINT       NULL,
    CONSTRAINT [PK_tblFacilityMicrosoftIdentificationAccount] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [Email] ASC)
);

