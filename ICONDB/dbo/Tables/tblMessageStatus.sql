CREATE TABLE [dbo].[tblMessageStatus] (
    [MessStatus] TINYINT      NOT NULL,
    [Descript]   VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_tblMessageStatus] PRIMARY KEY CLUSTERED ([MessStatus] ASC)
);

