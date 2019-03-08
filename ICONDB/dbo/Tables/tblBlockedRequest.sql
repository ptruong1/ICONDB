CREATE TABLE [dbo].[tblBlockedRequest] (
    [RequestId] TINYINT      NOT NULL,
    [Descript]  VARCHAR (50) NULL,
    CONSTRAINT [PK_tblBlockedRequest] PRIMARY KEY CLUSTERED ([RequestId] ASC)
);

