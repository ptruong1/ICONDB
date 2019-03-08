CREATE TABLE [dbo].[tblAuthCallControlTab] (
    [AuthID]       BIGINT NOT NULL,
    [RestrictedNo] BIT    CONSTRAINT [DF_Table_1_RestrictedNumber] DEFAULT ((1)) NULL,
    [NonRecordNo]  BIT    CONSTRAINT [DF_tblAuthCallControlTab_NonRecordNo] DEFAULT ((1)) NULL,
    [FreeNo]       BIT    CONSTRAINT [DF_tblAuthCallControlTab_FreeNo] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblAuthCallControlTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

