CREATE TABLE [dbo].[tblAlert] (
    [AlertID]     SMALLINT      NOT NULL,
    [Descript]    VARCHAR (50)  NULL,
    [AlertEmails] VARCHAR (250) NULL,
    [AlertPhones] VARCHAR (10)  NULL,
    CONSTRAINT [PK_tblAlert] PRIMARY KEY CLUSTERED ([AlertID] ASC)
);

