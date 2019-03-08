CREATE TABLE [dbo].[tblMenuLevel3] (
    [MenuID]         SMALLINT      NOT NULL,
    [Title]          NVARCHAR (50) NOT NULL,
    [URL]            NVARCHAR (50) NULL,
    [ParentIDLevel3] SMALLINT      NULL
);

