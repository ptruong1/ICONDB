CREATE TABLE [dbo].[tblTempUser] (
    [UserTemp] VARCHAR (25) NOT NULL,
    [Pass]     VARCHAR (20) NULL,
    CONSTRAINT [PK_tblTempUser] PRIMARY KEY CLUSTERED ([UserTemp] ASC)
);

