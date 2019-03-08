CREATE PROCEDURE [dbo].[INSERT_PINWatchListDetailsWithAlert]
(	
	@FacilityID int,
	@watchListID int,
	@DivisionID int,
	@LocationID int,
	@ANI char(10),
	@DNI char(10),
	@PIN char(12),
	@Username varchar(20),
	@WatchByID tinyint,
	@AlertEmails varchar(200),
	@AlertCellPhones varchar(200),
	@AlertRegPhone char(10),
	@HourlyFreq tinyint,
	@DailyFreq tinyint,
	@WeeklyFreq tinyint,
	@MonthlyFreq tinyint,
	@AlertMessage varchar(200)
)
AS
	SET NOCOUNT OFF; 

	DECLARE @count4 int;
	SELECT @count4 = COUNT(PIN) FROM [tblWatchList] WHERE (tblWatchList.PIN = @PIN AND tblWatchList.watchListID = @watchListID)
	IF @count4 > 0 --check to see if PIN is already in the watchlist
		RETURN -1;
	ELSE
	BEGIN
		INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID, [ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID]) VALUES (@watchListID, @LocationID, @DivisionID, @ANI, @DNI, @PIN, getdate(), @Username, @WatchByID);
		INSERT INTO [tblAlertPINs] ([PIN],[FacilityID],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@PIN,@FacilityID,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@@IDENTITY,@AlertMessage);
		RETURN 0;
	END
