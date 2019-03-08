CREATE TABLE [dbo].[tblWatchList] (
    [ID]              INT           NOT NULL,
    [watchListID]     INT           NOT NULL,
    [ANI]             NCHAR (10)    NULL,
    [DNI]             VARCHAR (16)  NULL,
    [PIN]             VARCHAR (12)  NULL,
    [LocationID]      INT           NULL,
    [inputdate]       SMALLDATETIME CONSTRAINT [DF_tblWatchList_inputdate] DEFAULT (getdate()) NULL,
    [modifyDate]      SMALLDATETIME NULL,
    [UserName]        VARCHAR (20)  NULL,
    [WatchByID]       TINYINT       NULL,
    [DivisionID]      INT           NULL,
    [StationID]       VARCHAR (50)  NULL,
    [ThirdPartyAlert] BIT           CONSTRAINT [DF__tblWatchL__Third__729BEF18] DEFAULT ((0)) NULL,
    [LocationTrace]   TINYINT       CONSTRAINT [DF__tblWatchL__Locat__73901351] DEFAULT ((0)) NULL,
    [InmateID]        VARCHAR (12)  NULL,
    [EmailInmateId]   VARCHAR (12)  NULL,
    CONSTRAINT [PK_tblWatchList] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_tblWatchList_tblUserWatch] FOREIGN KEY ([watchListID]) REFERENCES [dbo].[tblUserWatch] ([WatchListID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [ind_watchlistID]
    ON [dbo].[tblWatchList]([watchListID] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_watchbyID]
    ON [dbo].[tblWatchList]([WatchByID] ASC);


GO
CREATE TRIGGER [dbo].[Trg_LiveMoniotr] ON [dbo].[tblWatchList] 
FOR INSERT
AS
Declare  @watchListID  int, @ANI  varchar(10), @locationID int, @WatchByID int, @PIN varchar(12), @WatchListDetailID int, @DNI varchar(10)

Select  @WatchListDetailID= ID,  @watchListID = watchListID, @ANI = ANI, @DNI = DNI,  @PIN = PIN ,@WatchByID = WatchbyID, @locationID= locationID  from Inserted

If ( @locationID >0)
	INSERT INTO tblLivemonitor  (WatchListID,   CallingNo,  LocationID  ,    Watchby, WatchListDetailID )   
		SELECT @watchListID, ANINo,@LocationID, @WatchByID, @WatchListDetailID  from tblANIs  where LocationID = @LocationID

else
 begin
	select  @locationID = locationID from tblANIs with(nolock) where ANIno = @ANI 
	INSERT INTO tblLivemonitor  (WatchListID,   CallingNo,CalledNo, PIN,  LocationID  ,    Watchby, WatchListDetailID)   
		values( @watchListID, @ANI,@DNI,@PIN, @LocationID, @WatchByID, @WatchListDetailID )
 end
