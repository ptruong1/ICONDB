
CREATE PROCEDURE [dbo].[p_update_WatchList]
(
	@WatchListID int,
	@UserID varchar(20),
	@FacilityID int,
	@WatchListName varchar(30),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
Declare @UserAction varchar(200), @currentWatchListName varchar(200);
select @currentWatchListName = WatchListName from tblUserWatch	WHERE WatchListID=@WatchListID
UPDATE tblUserWatch SET WatchListName=@WatchListName WHERE WatchListID=@WatchListID

Set @UserAction = 'Update Watch List Name from ' + @currentWatchListName + ' to ' + @WatchListName
EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @UserID, @UserIP


