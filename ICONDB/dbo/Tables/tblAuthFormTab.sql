CREATE TABLE [dbo].[tblAuthFormTab] (
    [AuthID]      BIGINT NOT NULL,
    [InmateKite]  BIT    CONSTRAINT [DF_tblAuthFormTab_InmateKite] DEFAULT ((1)) NULL,
    [MedicalKite] BIT    CONSTRAINT [DF_tblAuthFormTab_MedicalKite] DEFAULT ((1)) NULL,
    [Grievance]   BIT    CONSTRAINT [DF_tblAuthFormTab_Grievance] DEFAULT ((1)) NULL,
    [LegalForm]   BIT    CONSTRAINT [DF_tblAuthFormTab_LegalForm] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblAuthFormTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

