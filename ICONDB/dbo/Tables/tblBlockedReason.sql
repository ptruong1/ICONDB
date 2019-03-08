CREATE TABLE [dbo].[tblBlockedReason] (
    [ReasonID]    TINYINT      NOT NULL,
    [Description] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblBlockedReason] PRIMARY KEY CLUSTERED ([ReasonID] ASC)
);

