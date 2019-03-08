
CREATE PROCEDURE  [dbo].[p_get_watchList]
@userID	varchar(20),
@Facility	int

AS
/*

If( select count (*) from  tblUserWatch  with(nolock) where UserID     = @userID and          FacilityID = @Facility ) > 0
	select WatchListID,  WatchListName  from tblUserWatch  with(nolock) where UserID     = @userID and          FacilityID = @Facility	Order by  WatchListID
else
	select 0, 'No Watchlist created'

*/
If( select count (*) from  tblUserWatch  with(nolock) where UserID     = @userID ) > 0
	select WatchListID,  WatchListName  from tblUserWatch  with(nolock) where UserID     = @userID Order by  WatchListID
else
	select 0, 'No Watchlist created'

