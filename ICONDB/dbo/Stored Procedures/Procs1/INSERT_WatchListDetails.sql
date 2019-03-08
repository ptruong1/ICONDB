



CREATE PROCEDURE [dbo].[INSERT_WatchListDetails]
(	
	@FacilityID int,
	@watchListID int,
	@LocationID int,
	@ANI nchar(10),
	@DNI nchar(10),
	@PIN bigint,
	@Username varchar(20),
	@WatchByID tinyint
)
AS
	SET NOCOUNT OFF; 

	----Monitor by ANI
	IF @WatchByID = 1
	BEGIN
		DECLARE @count1 int;
		SELECT @count1 = COUNT(ANINo) FROM tblANIs WHERE (tblANIs.ANINo = @ANI AND tblANIs.FacilityID = @FacilityID)
		IF @count1 > 0 --check to see if ANI is in the facility
		BEGIN
			DECLARE @count1a int;
			SELECT @count1a = COUNT(ANI) FROM [tblWatchList] WHERE (tblWatchList.ANI = @ANI AND tblWatchList.watchListID = @watchListID)
			IF @count1a > 0 --ANI EXIST IN THE Watchlist already
				RETURN -2;
			ELSE
			BEGIN
				INSERT INTO [tblWatchList] ([watchListID], LocationID, [ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID]) VALUES (@watchListID, @LocationID, @ANI, @DNI, @PIN, getdate(), @Username, @WatchByID)
				RETURN 0;
			END
		END
		ELSE
			RETURN -1;
	END
	
	----Monitor by DNI
	IF @WatchByID = 2
	BEGIN
		DECLARE @count4 int;
		SELECT @count4 = COUNT(DNI) FROM [tblWatchList] WHERE (tblWatchList.DNI = @DNI AND tblWatchList.watchListID = @watchListID)
		IF @count4 > 0 --check to see if DNI is already in the watchlist
			RETURN -2;
		ELSE
		BEGIN
			INSERT INTO [tblWatchList] ([watchListID], LocationID, [ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID]) VALUES (@watchListID, @LocationID, @ANI, @DNI, @PIN, getdate(), @Username, @WatchByID)
			RETURN 0;
		END
	END

	----Monitor by PIN
	IF @WatchByID = 3
	BEGIN
		DECLARE @count2 int; 
		SELECT @count2 = COUNT(PIN) FROM tblInmate WHERE (tblInmate.PIN = @PIN AND tblInmate.FacilityID = @FacilityID)
		IF @count2 > 0 --check to see if PIN is in the facility
		BEGIN
			DECLARE @count2a int;
			SELECT @count2a = COUNT(PIN) FROM [tblWatchList] WHERE (tblWatchList.PIN = @PIN AND tblWatchList.watchListID = @watchListID)
			IF @count2a > 0 --check to see if PIN is already in the watchlist
				RETURN -2;
			ELSE
			BEGIN
				INSERT INTO [tblWatchList] ([watchListID], LocationID, [ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID]) VALUES (@watchListID, @LocationID, @ANI, @DNI, @PIN, getdate(), @Username, @WatchByID)
				
				RETURN 0;
			END
		END
		ELSE
			RETURN -1;
	END

	----Monitor by Location
	IF @WatchByID = 4
	BEGIN
		DECLARE @count3 int;
		SELECT @count3 = COUNT(LocationID) FROM [tblWatchList] WHERE (tblWatchList.LocationID = @LocationID AND tblWatchList.watchListID = @watchListID)
		IF @count3 > 0 --check to see if pin is already in the watchlist
			RETURN -2;
		ELSE
		BEGIN
			INSERT INTO [tblWatchList] ([watchListID], LocationID, [ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID]) VALUES (@watchListID, @LocationID, @ANI, @DNI, @PIN, getdate(), @Username, @WatchByID)
			
			RETURN 0;
		END
	END


