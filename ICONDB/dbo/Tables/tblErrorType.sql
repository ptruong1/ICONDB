CREATE TABLE [dbo].[tblErrorType] (
    [ErrorType] TINYINT      NOT NULL,
    [Descript]  VARCHAR (30) NULL,
    CONSTRAINT [PK_tblErrorType] PRIMARY KEY CLUSTERED ([ErrorType] ASC)
);

