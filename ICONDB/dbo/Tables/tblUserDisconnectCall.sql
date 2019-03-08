CREATE TABLE [dbo].[tblUserDisconnectCall] (
    [RecordID]     BIGINT       NOT NULL,
    [CallDateTime] VARCHAR (30) NOT NULL,
    [StationID]    VARCHAR (30) NULL,
    [ToNo]         CHAR (10)    NULL,
    [PIN]          VARCHAR (12) NULL,
    [FacilityID]   INT          NULL,
    [Channel]      SMALLINT     NULL,
    [ACP]          VARCHAR (16) NULL,
    [RequestTime]  DATETIME     CONSTRAINT [DF_tblUserDisconnectCall_RequestTime] DEFAULT (getdate()) NULL,
    [UserName]     VARCHAR (30) NULL,
    CONSTRAINT [PK_tblUserDisconnectCall] PRIMARY KEY CLUSTERED ([RecordID] ASC, [CallDateTime] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_channel]
    ON [dbo].[tblUserDisconnectCall]([Channel] ASC, [ACP] ASC);

