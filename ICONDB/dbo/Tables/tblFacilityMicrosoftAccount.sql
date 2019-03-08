CREATE TABLE [dbo].[tblFacilityMicrosoftAccount] (
    [FacilityID]           BIGINT       NOT NULL,
    [Email]                VARCHAR (50) NOT NULL,
    [EmailLoginID]         VARCHAR (20) NULL,
    [EmailLoginPassword]   VARCHAR (12) NULL,
    [MicrosoftPassword]    VARCHAR (12) NULL,
    [AudioMiningPrimekey]  VARCHAR (50) NULL,
    [AudioMiningSecondkey] VARCHAR (50) NULL,
    [VoiceBioPrimeKey]     VARCHAR (50) NULL,
    [VoiceBioSecondKey]    VARCHAR (50) NULL,
    [InputDate]            DATETIME     CONSTRAINT [DF_tblFacilityMicrosoftAccount_Test_InputDate] DEFAULT (getdate()) NULL,
    [AudioMininingKeyPaid] BIT          NULL,
    [VoiceBioKeyPaid]      BIT          NULL,
    [DivID]                BIGINT       NULL,
    [SharedPort]           INT          NULL,
    CONSTRAINT [PK_tblFacilityMicrosoftAccount_Test] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [Email] ASC)
);

