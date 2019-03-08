
CREATE PROCEDURE [dbo].[INSERT_WatchList]
(
	@UserID varchar(20),
	@FacilityID int,
	@WatchListName varchar(30)
)
AS
	SET NOCOUNT OFF;
	Declare  @return_value int, @nextID int, @ID int, @tblUserWatch nvarchar(32) ;
   EXEC   @return_value = p_create_nextID 'tblUserWatch', @nextID   OUTPUT
    set           @ID = @nextID ; 
  INSERT INTO tblUserWatch ([WatchListID] ,[UserID], [FacilityID], [WatchListName], [modifydate])
        VALUES (@ID, @UserID, @FacilityID, @WatchListName, getdate());

--INSERT INTO tblUserWatch ([UserID], [FacilityID], [WatchListName], [modifydate]) VALUES (@UserID, @FacilityID, @WatchListName, getdate());

EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@UserID,'', @WatchListName

