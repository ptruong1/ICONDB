CREATE TABLE [dbo].[tblAuthMessageTab] (
    [AuthID]                 BIGINT NOT NULL,
    [AllMessage]             BIT    CONSTRAINT [DF_tblAuthMessageTab_AllMessage] DEFAULT ((1)) NULL,
    [EmailApprove]           BIT    CONSTRAINT [DF_tblAuthMessageTab_EmailApprove] DEFAULT ((1)) NULL,
    [VoiceMailApprove]       BIT    CONSTRAINT [DF_tblAuthMessageTab_VoiceMailApprove] DEFAULT ((1)) NULL,
    [Broadcast]              BIT    CONSTRAINT [DF_tblAuthMessageTab_Broadcast] DEFAULT ((1)) NULL,
    [SendInmateMessage]      BIT    CONSTRAINT [DF_tblAuthMessageTab_SendInmateMessage] DEFAULT ((1)) NULL,
    [Config]                 BIT    CONSTRAINT [DF_tblAuthMessageTab_Config] DEFAULT ((1)) NULL,
    [VideoMessageApprove]    BIT    NULL,
    [PictureExchangeApprove] BIT    NULL,
    CONSTRAINT [PK_tblAuthMessageTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

