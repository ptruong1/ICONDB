CREATE TABLE [dbo].[tblUserTemp] (
    [ID]    INT          IDENTITY (1, 1) NOT NULL,
    [UserN] VARCHAR (20) NOT NULL,
    [Pa]    VARCHAR (20) NULL,
    CONSTRAINT [PK_tblTest] PRIMARY KEY CLUSTERED ([UserN] ASC)
);

