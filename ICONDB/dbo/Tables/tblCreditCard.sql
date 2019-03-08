CREATE TABLE [dbo].[tblCreditCard] (
    [CCprefix]    VARCHAR (4)  NOT NULL,
    [CCType]      VARCHAR (1)  NULL,
    [CCLength]    VARCHAR (16) NOT NULL,
    [Description] VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_prefix]
    ON [dbo].[tblCreditCard]([CCprefix] ASC, [CCLength] ASC);

