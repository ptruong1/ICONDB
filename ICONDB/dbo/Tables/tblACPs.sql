CREATE TABLE [dbo].[tblACPs] (
    [Id]           INT          NOT NULL,
    [IpAddress]    VARCHAR (16) NOT NULL,
    [ComputerName] VARCHAR (15) NULL,
    [DriveMap]     CHAR (1)     NULL,
    [Status]       TINYINT      NULL,
    CONSTRAINT [PK_tblACPs] PRIMARY KEY CLUSTERED ([IpAddress] ASC)
);

