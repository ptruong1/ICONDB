CREATE TABLE [dbo].[tblUserFavorites1] (
    [UserID]       VARCHAR (20)   NOT NULL,
    [Title]        VARCHAR (50)   NULL,
    [URL]          VARCHAR (100)  NULL,
    [InputDate]    SMALLDATETIME  NULL,
    [ModifyDate]   SMALLDATETIME  NULL,
    [ID]           SMALLINT       NULL,
    [sqlStatement] VARCHAR (4000) NULL
);

