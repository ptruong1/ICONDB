CREATE TABLE [dbo].[tblUserWatch] (
    [WatchListID]   INT           NOT NULL,
    [UserID]        VARCHAR (20)  NULL,
    [FacilityID]    INT           NULL,
    [WatchListName] VARCHAR (30)  NULL,
    [inputdate]     SMALLDATETIME CONSTRAINT [DF_tblUserWatch_inputdate] DEFAULT (getdate()) NULL,
    [modifydate]    SMALLDATETIME NULL,
    CONSTRAINT [PK_tblUserWatch] PRIMARY KEY CLUSTERED ([WatchListID] ASC),
    CONSTRAINT [FK_tblUserWatch_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID]),
    CONSTRAINT [FK_tblUserWatchList_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);


GO
CREATE TRIGGER [Trg_delete_LiveMonitor] ON dbo.tblUserWatch 
FOR DELETE 
AS

declare @WatchListID int
Select  @WatchListID= WatchlistID  from Deleted
Delete from  tblLivemonitor  where WatchListID =  @WatchListID
