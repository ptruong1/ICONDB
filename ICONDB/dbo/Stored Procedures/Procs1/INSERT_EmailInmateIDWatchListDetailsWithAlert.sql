CREATE PROCEDURE [dbo].[INSERT_EmailInmateIDWatchListDetailsWithAlert]
(	
	@FacilityID int,
	@watchListID int,
	@DivisionID int,
	@LocationID int,
	@ANI char(10),
	@DNI char(10),
	@PIN char(12),
	@InmateID varchar(12),
	@Username varchar(20),
	@WatchByID tinyint,
	@AlertEmails varchar(200),
	@AlertCellPhones varchar(200),
	@AlertRegPhone char(10),
	@HourlyFreq tinyint,
	@DailyFreq tinyint,
	@WeeklyFreq tinyint,
	@MonthlyFreq tinyint,
	@AlertMessage varchar(200),
	@ThirdPartyAlert bit,
	@LocationTrace tinyint
)
AS
	SET NOCOUNT OFF; 

	DECLARE @count7 int;
	Declare  @return_value int, @nextID int, @ID int, @tblWatchList nvarchar(32) ;
	SELECT @count7 = COUNT(EmailInmateId) FROM [tblWatchList] WHERE (tblWatchList.EmailInmateId = @InmateId AND tblWatchList.watchListID = @watchListID)
	IF @count7 > 0 --check to see if PIN is already in the watchlist
		RETURN -1;
	ELSE
	BEGIN
     	EXEC   @return_value = p_create_nextID 'tblWatchList', @nextID   OUTPUT
        set           @ID = @nextID ; 
		INSERT INTO [tblWatchList] ([ID],[watchListID], LocationID, DivisionID, [ANI], [DNI], [PIN], EmailInmateID, [modifyDate], [Username], [WatchByID],[ThirdPartyAlert],[LocationTrace]) 
		    VALUES (@ID, @watchListID, @LocationID, @DivisionID, @ANI, @DNI, @PIN, @InmateID, getdate(), @Username, @WatchByID,@ThirdPartyAlert,@LocationTrace);
		INSERT INTO [tblAlertEmailInmates] ([EmailInmateID],[FacilityID],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@InmateID,@FacilityID,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@ID,@AlertMessage);
		RETURN 0;
	END

	--DECLARE @count4 int;
	--SELECT @count4 = COUNT(PIN) FROM [tblWatchList] WHERE (tblWatchList.PIN = @PIN AND tblWatchList.watchListID = @watchListID)
	--IF @count4 > 0 --check to see if PIN is already in the watchlist
	--	RETURN -1;
	--ELSE
	--BEGIN
	--	INSERT INTO [tblWatchList] ([watchListID], LocationID, DivisionID, [ANI], [DNI], [PIN], [modifyDate], [Username], [WatchByID],[ThirdPartyAlert],[LocationTrace]) VALUES (@watchListID, @LocationID, @DivisionID, @ANI, @DNI, @PIN, getdate(), @Username, @WatchByID,@ThirdPartyAlert,@LocationTrace);
	--	INSERT INTO [tblAlertPINs] ([PIN],[FacilityID],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
	--		   VALUES (@PIN,@FacilityID,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@@IDENTITY,@AlertMessage);
	--	RETURN 0;
	--END
