CREATE TABLE [dbo].[tblVisitadmin_users] (
    [id]        INT           NOT NULL,
    [username]  VARCHAR (255) NOT NULL,
    [passmd5]   VARCHAR (255) NOT NULL,
    [access]    INT           NULL,
    [lastlogin] BIGINT        NULL
);

