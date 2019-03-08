
create PROCEDURE [dbo].[p_delete_WatchList_v1]
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

DELETE FROM [tblAlertANIs] WHERE WatchListDetailID in (select ID from tblWatchList where watchListID=@WatchListID)
DELETE FROM [tblAlertPhones] WHERE WatchListDetailID in (select ID from tblWatchList where watchListID=@WatchListID)
DELETE FROM [tblAlertPINs] WHERE WatchListDetailID in (select ID from tblWatchList where watchListID=@WatchListID)
DELETE FROM [tblAlertLocations] WHERE WatchListDetailID in (select ID from tblWatchList where watchListID=@WatchListID)

DELETE FROM tblUserWatch WHERE [WatchListID] = @WatchListID 


Set @UserAction = 'Delete Watch List Name: ' + @currentWatchListName 
EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @UserID, @UserIP


