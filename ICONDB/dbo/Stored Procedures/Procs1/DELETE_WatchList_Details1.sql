
CREATE PROCEDURE [dbo].[DELETE_WatchList_Details1]
(
	@WatchListDetailID int,
	@WatchByID int
)
AS
	SET NOCOUNT OFF;
	DECLARE @count int;

    If @WatchByID = 1 -- by Source
       Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertANIs] WHERE WatchListDetailID = @WatchListDetailID
	IF @count > 0 --check to see if ANI is already in the watchlist
	begin
		DELETE FROM [tblAlertANIs] WHERE WatchListDetailID = @WatchListDetailID
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
	end
	
	Else
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
       End
   else
   If @WatchByID = 2 -- By DNI
      Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertPhones] WHERE WatchListDetailID = @WatchListDetailID
	IF @count > 0 --check to see if DNI is already in the watchlist
	begin
		DELETE FROM [tblAlertPhones] WHERE WatchListDetailID = @WatchListDetailID
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
	end
	
	Else
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
      End
   else
   If @WatchByID = 3 -- By PIN
      Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertPINs] WHERE WatchListDetailID = @WatchListDetailID
	IF @count > 0 --check to see if DNI is already in the watchlist
	begin
		DELETE FROM [tblAlertPINs] WHERE WatchListDetailID = @WatchListDetailID
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
	end
	
	Else
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
      End
   else
   If @WatchByID = 4 -- Division
       Begin
	
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
      End
  else
      Begin
 	-- By Location
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertPhones] WHERE WatchListDetailID = @WatchListDetailID
	IF @count > 0 --check to see if DNI is already in the watchlist
	begin
		DELETE FROM [tblAlertLocations] WHERE WatchListDetailID = @WatchListDetailID
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
	end
	
	Else
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
      End
