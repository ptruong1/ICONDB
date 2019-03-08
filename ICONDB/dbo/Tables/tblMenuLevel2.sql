CREATE TABLE [dbo].[tblMenuLevel2] (
    [MenuID]         SMALLINT      NOT NULL,
    [Title]          NVARCHAR (50) NOT NULL,
    [URL]            NVARCHAR (50) NULL,
    [ParentIDLevel2] SMALLINT      NOT NULL,
    [ChildMenu]      BIT           NULL
);

