CREATE TABLE [dbo].[tblRecordingPlayList] (
    [PlayListID]   INT           NOT NULL,
    [PlayListName] VARCHAR (50)  NULL,
    [UserName]     VARCHAR (25)  NULL,
    [CreatedDate]  SMALLDATETIME CONSTRAINT [DF_tblRecordingPlayList_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblRecordingPlayList] PRIMARY KEY CLUSTERED ([PlayListID] ASC)
);

