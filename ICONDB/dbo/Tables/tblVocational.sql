CREATE TABLE [dbo].[tblVocational] (
    [VocID]        INT          NOT NULL,
    [MediaType]    TINYINT      NULL,
    [VocName]      VARCHAR (50) NULL,
    [VocCreator]   VARCHAR (30) NULL,
    [VocPublisher] VARCHAR (50) NULL,
    [VocCatID]     TINYINT      NULL,
    [InputDate]    DATETIME     NULL,
    [Modifydate]   DATETIME     NULL,
    [UserName]     VARCHAR (25) NULL,
    CONSTRAINT [PK_tblVocational] PRIMARY KEY CLUSTERED ([VocID] ASC)
);

