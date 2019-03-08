CREATE TABLE [dbo].[tblMenuLevel1] (
    [MenuID]         SMALLINT      NOT NULL,
    [Title]          NVARCHAR (50) NOT NULL,
    [URL]            NVARCHAR (50) NULL,
    [ParentIDLevel1] SMALLINT      NULL
);

