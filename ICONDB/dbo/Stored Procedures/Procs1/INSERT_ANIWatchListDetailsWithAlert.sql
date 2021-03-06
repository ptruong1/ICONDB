﻿CREATE PROCEDURE [dbo].[INSERT_ANIWatchListDetailsWithAlert]
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
	@StationID varchar(50),
	@AlertMessage varchar(200)
)
AS
	SET NOCOUNT OFF; 

	DECLARE @count4 int;
	SELECT @count4 = COUNT(ANI) FROM [tblWatchList] WHERE (tblWatchList.ANI = @ANI AND tblWatchList.watchListID = @watchListID)
	IF @count4 > 0 --check to see if ANI is already in the watchlist
		RETURN -1;
	ELSE
	BEGIN
		INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID, [ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[StationID]) VALUES (@watchListID, @LocationID, @DivisionID, @ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@StationID);
		INSERT INTO [tblAlertANIs] ([ANINo],[FacilityID],[Username],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[StationID],[AlertMessage])
			   VALUES (@ANI,@FacilityID,@Username,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@@IDENTITY,@StationID,@AlertMessage);
		RETURN 0;
	END
