CREATE TABLE [dbo].[tblRequestStatus] (
    [RequestStatus] TINYINT      NOT NULL,
    [Descript]      VARCHAR (15) NULL,
    CONSTRAINT [PK_tblRequestStatus] PRIMARY KEY CLUSTERED ([RequestStatus] ASC)
);

