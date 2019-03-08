CREATE TABLE [dbo].[aLinks] (
    [id]       INT           NOT NULL,
    [parentId] INT           NULL,
    [Text]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_aLinks] PRIMARY KEY CLUSTERED ([id] ASC)
);

