CREATE TABLE [dbo].[tblANItimeCall] (
    [ANI]        CHAR (10)     NOT NULL,
    [days]       TINYINT       NOT NULL,
    [hours]      BIGINT        NULL,
    [inputdate]  SMALLDATETIME CONSTRAINT [DF_tblANItimeCall_inputdate] DEFAULT (getdate()) NULL,
    [modifydate] SMALLDATETIME NULL,
    [userName]   VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblANItimeCall] PRIMARY KEY CLUSTERED ([ANI] ASC, [days] ASC)
);

