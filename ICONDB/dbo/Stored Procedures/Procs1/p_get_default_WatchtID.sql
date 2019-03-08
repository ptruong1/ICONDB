
CREATE PROCEDURE [dbo].[p_get_default_WatchtID]
@userID	varchar(20),
@facilityID	int
 AS
SET NOCOUNT ON
--declare @WatchListID int
/*

	If( select count(*) from tblUserWatch with(nolock)  where UserID = @userID and facilityID = @facilityID ) >0
		select  top 1  isnull(  WatchListID,0)  WatchListID from  tblUserWatch with(nolock)  where UserID = @userID and facilityID = @facilityID order by  WatchListID
	else 
		select 0, 'No Watchlist is created'

*/
 If( select count(*) from tblUserWatch with(nolock)  where UserID = @userID ) >0
		select  top 1  isnull(  WatchListID,0)  WatchListID from  tblUserWatch with(nolock)  where UserID = @userID order by  WatchListID
	else 
		select 0, 'No Watchlist is created'

