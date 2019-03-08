CREATE TABLE [dbo].[tblEndusers_backUp] (
    [EndUserID]    INT           NOT NULL,
    [UserName]     VARCHAR (20)  NULL,
    [Password]     VARCHAR (20)  NULL,
    [Email]        VARCHAR (50)  NULL,
    [contactPhone] VARCHAR (10)  NULL,
    [SecurityQ]    TINYINT       NOT NULL,
    [SecurityA]    VARCHAR (100) NULL
);

