CREATE TABLE [dbo].[tblUserWatchList] (
    [WatchListID]   INT           NOT NULL,
    [UserID]        VARCHAR (20)  NULL,
    [FacilityID]    INT           NULL,
    [WatchListName] VARCHAR (30)  NULL,
    [inputdate]     SMALLDATETIME CONSTRAINT [DF_tblUserWatchList_inputdate] DEFAULT (getdate()) NULL,
    [modifydate]    SMALLDATETIME NULL,
    CONSTRAINT [PK_tblUserWatchList] PRIMARY KEY CLUSTERED ([WatchListID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_user_facilityID]
    ON [dbo].[tblUserWatchList]([UserID] ASC, [FacilityID] ASC);

