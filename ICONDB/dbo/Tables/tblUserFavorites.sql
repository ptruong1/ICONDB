CREATE TABLE [dbo].[tblUserFavorites] (
    [UserID]     VARCHAR (20)  NOT NULL,
    [Title]      VARCHAR (50)  NOT NULL,
    [URL]        VARCHAR (100) NOT NULL,
    [InputDate]  SMALLDATETIME NULL,
    [ModifyDate] SMALLDATETIME NULL,
    [ID]         SMALLINT      NULL,
    CONSTRAINT [PK_tblUserFavorites] PRIMARY KEY CLUSTERED ([UserID] ASC, [Title] ASC, [URL] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_user_favorate]
    ON [dbo].[tblUserFavorites]([UserID] ASC, [Title] ASC, [URL] ASC);

