
CREATE PROCEDURE [dbo].[p_Delete_WatchList_Details]
(
	@WatchListDetailID int,
	@WatchByID int,
	@UserIP varchar(25),
	@FacilityID int,
	@Username varchar(20)
)
AS
	SET NOCOUNT OFF;
	DECLARE @count int;
	Declare @UserAction varchar(200), @WatchListName varchar(200);
		select @WatchListName= WatchListName from tblUserWatch a inner join tblWatchList b on a.WatchListID = b.watchListID
		 WHERE ID=@WatchListDetailID
    If @WatchByID = 1 -- by Source
       Begin
			SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertANIs] WHERE WatchListDetailID = @WatchListDetailID
			IF @count > 0 --check to see if ANI is already in the watchlist
				begin
					DELETE FROM [tblAlertANIs] WHERE WatchListDetailID = @WatchListDetailID
					DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
				end
			Else
				begin
					DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
				end
			Set @UserAction = 'Delete Watch List Detail ANI from: ' + @WatchListName 
			EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
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
			begin
				DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
			end
			Set @UserAction = 'Delete Watch List Detail DNI from: ' + @WatchListName 
			EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
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
			begin
				DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
			end
			Set @UserAction = 'Delete Watch List Detail PIN from: ' + @WatchListName 
			EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		  End
   else
   If @WatchByID = 4 -- Location
       Begin
	        DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
		    Set @UserAction = 'Delete Watch List Detail Location from: ' + @WatchListName 
			EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
      End
  else
      Begin
 	-- By Division
		SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertPhones] WHERE WatchListDetailID = @WatchListDetailID
		IF @count > 0 --check to see if DNI is already in the watchlist
		begin
			DELETE FROM [tblAlertLocations] WHERE WatchListDetailID = @WatchListDetailID
			DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
		end
		
		Else
		 begin
			DELETE FROM [tblWatchList] WHERE ID = @WatchListDetailID
		end
			Set @UserAction = 'Delete Watch List Detail Division from: ' + @WatchListName 
			EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
      End
