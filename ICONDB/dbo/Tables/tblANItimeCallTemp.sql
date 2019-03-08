CREATE TABLE [dbo].[tblANItimeCallTemp] (
    [ANI]        CHAR (10)     NOT NULL,
    [days]       TINYINT       NOT NULL,
    [hours]      BIGINT        NULL,
    [inputdate]  SMALLDATETIME NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblANItimeCallTemp] PRIMARY KEY CLUSTERED ([ANI] ASC, [days] ASC)
);

