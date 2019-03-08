CREATE TABLE [dbo].[tblIndTables] (
    [TableName] NVARCHAR (32) NOT NULL,
    [FieldID]   NVARCHAR (25) NULL,
    [CurrentID] BIGINT        NULL,
    CONSTRAINT [PK_tblIndTables] PRIMARY KEY CLUSTERED ([TableName] ASC)
);

