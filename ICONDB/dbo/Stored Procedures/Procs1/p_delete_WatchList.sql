
CREATE PROCEDURE [dbo].[p_delete_WatchList]
(
	@WatchListID int,
	@UserID varchar(20),
	@FacilityID int,
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
Declare @UserAction varchar(200), @currentWatchListName varchar(200);
select @currentWatchListName = WatchListName from tblUserWatch	WHERE WatchListID=@WatchListID
DELETE FROM tblUserWatch WHERE [WatchListID] = @WatchListID 

Set @UserAction = 'Delete Watch List Name: ' + @currentWatchListName 
EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @UserID, @UserIP


