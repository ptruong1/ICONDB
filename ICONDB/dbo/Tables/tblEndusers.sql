CREATE TABLE [dbo].[tblEndusers] (
    [EndUserID]    INT             NOT NULL,
    [UserName]     VARCHAR (20)    NULL,
    [Password]     VARCHAR (20)    NULL,
    [Email]        VARCHAR (50)    NULL,
    [contactPhone] VARCHAR (10)    NULL,
    [SecurityQ]    TINYINT         CONSTRAINT [DF_tblEndusers_SecurityQ] DEFAULT ((0)) NOT NULL,
    [SecurityA]    VARCHAR (100)   NULL,
    [PassDEC]      VARBINARY (200) NULL,
    CONSTRAINT [PK_tblEndusers1] PRIMARY KEY CLUSTERED ([EndUserID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_user_pass]
    ON [dbo].[tblEndusers]([UserName] ASC, [Password] ASC);

