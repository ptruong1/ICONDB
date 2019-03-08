CREATE TABLE [dbo].[tblAuthVideoVisitTab] (
    [AuthID]      BIGINT NOT NULL,
    [Config]      BIT    CONSTRAINT [DF_tblAuthVideoVisitTab_Config] DEFAULT ((1)) NULL,
    [Utilities]   BIT    CONSTRAINT [DF_tblAuthVideoVisitTab_Utilities] DEFAULT ((1)) NULL,
    [InmateForms] BIT    NULL,
    [PhoneVisit]  BIT    NULL,
    CONSTRAINT [PK_tblAuthVideoVisitTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

