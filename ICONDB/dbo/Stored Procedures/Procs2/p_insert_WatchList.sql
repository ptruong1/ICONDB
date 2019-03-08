
CREATE PROCEDURE [dbo].[p_insert_WatchList]
(
	@UserID varchar(20),
	@FacilityID int,
	@WatchListName varchar(30),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;

Declare @UserAction varchar(200);
Declare  @return_value int, @nextID int, @ID int, @tblUserWatch nvarchar(32) ;
   EXEC   @return_value = p_create_nextID 'tblUserWatch', @nextID   OUTPUT
    set           @ID = @nextID ; 	
	INSERT INTO tblUserWatch ([WatchListID] ,[UserID], [FacilityID], [WatchListName], [modifydate])
     VALUES (@ID, @UserID, @FacilityID, @WatchListName, getdate());

--INSERT INTO tblUserWatch ([UserID], [FacilityID], [WatchListName], [modifydate]) VALUES (@UserID, @FacilityID, @WatchListName, getdate());

Set @UserAction = 'Insert Watch List Name: ' + @WatchListName
EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @UserID, @UserIP


