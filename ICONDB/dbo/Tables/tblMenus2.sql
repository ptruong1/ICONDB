CREATE TABLE [dbo].[tblMenus2] (
    [MenuId]          INT            NOT NULL,
    [ParentMenuId]    INT            NOT NULL,
    [Title]           VARCHAR (250)  NULL,
    [DescriptionMenu] VARCHAR (250)  NULL,
    [Url]             NVARCHAR (100) NOT NULL
);

