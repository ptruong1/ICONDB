CREATE PROCEDURE [dbo].[Update_WatchListDetailsWithAlert]
(	
	@WatchByID int,
	@WatchListDetailID int,
	@FacilityID int,
	@watchListID int,
	@DivisionID int,
	@LocationID int,
	@ANI char(10),
	@DNI char(10),
	@PIN bigint,
	@Username varchar(20),
	@AlertEmails varchar(200),
	@AlertCellPhones varchar(200),
	@AlertRegPhone char(10),
	@HourlyFreq tinyint,
	@DailyFreq tinyint,
	@WeeklyFreq tinyint,
	@MonthlyFreq tinyint,
	@AlertMessage varchar(200),
	@StationID varchar(50)
)
AS
	SET NOCOUNT OFF; 
	DECLARE @count int;
If @watchByID = 1
Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertANIs] WHERE WatchListDetailID =  @WatchListDetailID 
	IF @count > 0 --check to see if ANI alert is already in the watchlist
		BEGIN
		
		Update [tblAlertANIs]  set
	              
               	 [AlertEmails]=@AlertEmails,
                	[AlertCellPhones]=@AlertCellPhones,
		[AlertRegPhone]=@AlertRegPhone,
		[HourlyFreq]=@HourlyFreq,
		[DailyFreq]=@DailyFreq,
		[WeeklyFreq]=@WeeklyFreq,
		[MonthlyFreq]=@MonthlyFreq,
		[AlertMessage]=@AlertMessage

		where WatchListDetailID = @WatchListDetailID

		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@ANI
			   
		RETURN 0;
		
	 	END
	ELSE
	if @count = 0
	  			   
	BEGIN
		
		INSERT INTO [tblAlertANIs] ([ANINo],[StationID],[FacilityID],[Username],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@ANI,@StationID,@FacilityID,@Username,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);
		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@ANI
		RETURN 1;
	END
	else
	Begin
		RETURN -1;
	End
End
else
If @watchByID = 2
Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertPhones] WHERE WatchListDetailID =  @WatchListDetailID 
	IF @count > 0 --check to see if DNI is already in the watchlist
		BEGIN
		
		
		Update [tblAlertPhones]  set
	                 [Username]=@Username,
               	 [AlertEmails]=@AlertEmails,
                	[AlertCellPhones]=@AlertCellPhones,
		[AlertRegPhone]=@AlertRegPhone,
		[HourlyFreq]=@HourlyFreq,
		[DailyFreq]=@DailyFreq,
		[WeeklyFreq]=@WeeklyFreq,
		[MonthlyFreq]=@MonthlyFreq,
		[AlertMessage]=@AlertMessage
		where WatchListDetailID = @WatchListDetailID
		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@DNI
		RETURN 0;
		
	 	END
	ELSE
	if @count = 0
	  BEGIN
		INSERT INTO [tblAlertPhones] ([PhoneNo],[FacilityID],[Username],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@DNI,@FacilityID,@Username,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);
			   
		RETURN 1;
	 END
	else
	Begin
		RETURN -1;
	End
end
else
If @watchByID = 3
Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertPINs] WHERE WatchListDetailID =  @WatchListDetailID 
	IF @count > 0 --check to see if DNI is already in the watchlist
		BEGIN
		
		Update [tblAlertPINs]  set
	             
               	 [AlertEmails]=@AlertEmails,
                	[AlertCellPhones]=@AlertCellPhones,
		[AlertRegPhone]=@AlertRegPhone,
		[HourlyFreq]=@HourlyFreq,
		[DailyFreq]=@DailyFreq,
		[WeeklyFreq]=@WeeklyFreq,
		[MonthlyFreq]=@MonthlyFreq,
		[AlertMessage]=@AlertMessage

		where WatchListDetailID = @WatchListDetailID
		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@PIN
		RETURN 0;
	 END
	ELSE
	if @count = 0
	  BEGIN
		INSERT INTO [tblAlertPINs] ([PIN],[FacilityID],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@PIN,@FacilityID,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);
		EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@PIN
		RETURN 1;
	 END
	else
	Begin
		RETURN -1;
	End
end
	  
else
If @watchByID = 4
	begin
		
		
			   
		RETURN 0;
	 END
else

	  BEGIN
		
		
			   
		RETURN 0;
	 END
