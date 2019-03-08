
CREATE PROCEDURE [dbo].[INSERT_WatchListDetails2]
(	
	@FacilityID int,
	@watchListID int,
	@LocationID int,
	@DivisionID int,
	@ANI nchar(10),
	@DNI nchar(10),
	@PIN nchar(12),
	@Username varchar(20),
	@WatchByID tinyint,
	@StationID varchar(50),
	@ThirdPartyAlert bit,
	@LocationTrace tinyint
)
AS
	SET NOCOUNT OFF;
	
	IF @WatchByID = 1
	BEGIN
		DECLARE @count1 int;
		Declare  @return_value int, @nextID int, @ID int, @tblWatchList nvarchar(32) ;
		SELECT @count1 = COUNT(ANINo) FROM tblANIs WHERE (tblANIs.ANINo = @ANI AND tblANIs.FacilityID = @FacilityID)
		IF @count1 > 0 --check to see if ANI is in the facility
		BEGIN
			DECLARE @count1a int;
			SELECT @count1a = COUNT(ANI) FROM [tblWatchList] WHERE (tblWatchList.ANI = @ANI AND tblWatchList.watchListID = @watchListID)
			IF @count1a > 0 --ANI EXIST IN THE Watchlist already
				RETURN -2;
			ELSE
			BEGIN
				EXEC   @return_value = p_create_nextID 'tblWatchList', @nextID   OUTPUT
                set           @ID = @nextID ;
				INSERT INTO [tblWatchList] ([ID], [watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
					 VALUES (@ID, @watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
				EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@ANI
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
			EXEC   @return_value = p_create_nextID 'tblWatchList', @nextID   OUTPUT
                set           @ID = @nextID ;
			INSERT INTO [tblWatchList] ([ID], [watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
					 VALUES (@ID, @watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
			EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@DNI
			RETURN 0;
		END
	END

	----Monitor by PIN
	IF @WatchByID = 3
	BEGIN
		DECLARE @count2 int; 
		
		BEGIN
			DECLARE @count2a int;
			SELECT @count2a = COUNT(PIN) FROM [tblWatchList] WHERE (tblWatchList.PIN = @PIN AND tblWatchList.watchListID = @watchListID)
			IF @count2a > 0 --check to see if PIN is already in the watchlist
				RETURN -2;
			ELSE
			BEGIN
				EXEC   @return_value = p_create_nextID 'tblWatchList', @nextID   OUTPUT
                set           @ID = @nextID ;
				INSERT INTO [tblWatchList] ([ID], [watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
					 VALUES (@ID, @watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
				EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@PIN
				RETURN 0;
			END
		END
		
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
			EXEC   @return_value = p_create_nextID 'tblWatchList', @nextID   OUTPUT
                set           @ID = @nextID ;
			INSERT INTO [tblWatchList] ([ID], [watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
					 VALUES (@ID, @watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
			EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@locationID
			RETURN 0;
		END
	END
	IF @WatchByID =5 
	BEGIN
		DECLARE @count5 int;
		SELECT @count5 = COUNT(DivisionID) FROM [tblWatchList] WHERE (tblWatchList.DivisionID = @DivisionID AND tblWatchList.watchListID = @watchListID and tblWatchList.LocationID = @LocationID)
		IF @count5 > 0 --check to see if pin is already in the watchlist
			RETURN -2;
		ELSE
		BEGIN
			EXEC   @return_value = p_create_nextID 'tblWatchList', @nextID   OUTPUT
                set           @ID = @nextID ;
			INSERT INTO [tblWatchList] ([ID], [watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
					 VALUES (@ID, @watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
			EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@divisionID
			RETURN 0;
		END
	END
	 

	------Monitor by ANI
	--IF @WatchByID = 1
	--BEGIN
	--	DECLARE @count1 int;
	--	SELECT @count1 = COUNT(ANINo) FROM tblANIs WHERE (tblANIs.ANINo = @ANI AND tblANIs.FacilityID = @FacilityID)
	--	IF @count1 > 0 --check to see if ANI is in the facility
	--	BEGIN
	--		DECLARE @count1a int;
	--		SELECT @count1a = COUNT(ANI) FROM [tblWatchList] WHERE (tblWatchList.ANI = @ANI AND tblWatchList.watchListID = @watchListID)
	--		IF @count1a > 0 --ANI EXIST IN THE Watchlist already
	--			RETURN -2;
	--		ELSE
	--		BEGIN
	--			INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
	--				 VALUES (@watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
	--			EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@ANI
	--			RETURN 0;
	--		END
	--	END
	--	ELSE
	--		RETURN -1;
	--END
	
	------Monitor by DNI
	--IF @WatchByID = 2
	--BEGIN
	--	DECLARE @count4 int;
	--	SELECT @count4 = COUNT(DNI) FROM [tblWatchList] WHERE (tblWatchList.DNI = @DNI AND tblWatchList.watchListID = @watchListID)
	--	IF @count4 > 0 --check to see if DNI is already in the watchlist
	--		RETURN -2;
	--	ELSE
	--	BEGIN
	--		INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
	--				 VALUES (@watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
	--		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@DNI
	--		RETURN 0;
	--	END
	--END

	------Monitor by PIN
	--IF @WatchByID = 3
	--BEGIN
	--	DECLARE @count2 int; 
		
	--	BEGIN
	--		DECLARE @count2a int;
	--		SELECT @count2a = COUNT(PIN) FROM [tblWatchList] WHERE (tblWatchList.PIN = @PIN AND tblWatchList.watchListID = @watchListID)
	--		IF @count2a > 0 --check to see if PIN is already in the watchlist
	--			RETURN -2;
	--		ELSE
	--		BEGIN
	--			INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
	--				 VALUES (@watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
	--			EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@PIN
	--			RETURN 0;
	--		END
	--	END
		
	--END

	------Monitor by Location
	--IF @WatchByID = 4
	--BEGIN
	--	DECLARE @count3 int;
	--	SELECT @count3 = COUNT(LocationID) FROM [tblWatchList] WHERE (tblWatchList.LocationID = @LocationID AND tblWatchList.watchListID = @watchListID)
	--	IF @count3 > 0 --check to see if pin is already in the watchlist
	--		RETURN -2;
	--	ELSE
	--	BEGIN
	--		INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
	--				 VALUES (@watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
	--		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@locationID
	--		RETURN 0;
	--	END
	--END
	--IF @WatchByID =5 
	--BEGIN
	--	DECLARE @count5 int;
	--	SELECT @count5 = COUNT(DivisionID) FROM [tblWatchList] WHERE (tblWatchList.DivisionID = @DivisionID AND tblWatchList.watchListID = @watchListID and tblWatchList.LocationID = @LocationID)
	--	IF @count5 > 0 --check to see if pin is already in the watchlist
	--		RETURN -2;
	--	ELSE
	--	BEGIN
	--		INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID,[ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID], [ThirdPartyAlert],[LocationTrace])
	--				 VALUES (@watchListID, @LocationID, @DivisionID,@ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID,@ThirdPartyAlert,@LocationTrace)
	--		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@divisionID
	--		RETURN 0;
	--	END
	--END
