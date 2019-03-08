
CREATE PROCEDURE [dbo].[DELETE_WatchList_Details]
(
	@WatchListDetailID int
)
AS
	SET NOCOUNT OFF;
DECLARE @count int;
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertPhones] WHERE WatchListDetailID = @WatchListDetailID
	IF @count > 0 --check to see if DNI is already in the watchlist
	begin
		DELETE FROM [tblAlertPhones] WHERE WatchListDetailID = @WatchListDetailID
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
	end
	
	Else
		DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID

