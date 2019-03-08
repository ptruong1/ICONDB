CREATE PROCEDURE [dbo].[p_Update_WatchListDetailsWithAlert2]
(	
	@WatchByID int,
	@WatchListDetailID int,
	@FacilityID int,
	@watchListID int,
	@DivisionID int,
	@LocationID int,
	@ANI char(10),
	@DNI char(10),
	@PIN varchar(12),
	@InmateID varchar(12),
	@Username varchar(20),
	@AlertEmails varchar(200),
	@AlertCellPhones varchar(200),
	@AlertRegPhone char(10),
	@HourlyFreq tinyint,
	@DailyFreq tinyint,
	@WeeklyFreq tinyint,
	@MonthlyFreq tinyint,
	@AlertMessage varchar(200),
	@StationID varchar(50),
	@ThirdPartyAlert bit,
	@UserIP varchar(25),
	@LocationTrace tinyint
)
AS
	SET NOCOUNT OFF; 
	DECLARE @count int;
	Declare @UserAction varchar(200), @WatchListName varchar(200);
	select @WatchListName= WatchListName from tblUserWatch a inner join tblWatchList b on a.WatchListID = b.watchListID
		 WHERE ID=@WatchListDetailID
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

		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		Set @UserAction = 'Update Watch List Detail ANI ' +  CAST (@ANI as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
					   
		RETURN 0;
		
	 	END
	ELSE
	if @count = 0
	  			   
	BEGIN
		
		INSERT INTO [tblAlertANIs] ([ANINo],[StationID],[FacilityID],[Username],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@ANI,@StationID,@FacilityID,@Username,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);
		
		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

	Set @UserAction = 'Update Watch List Detail ANI ' +  CAST (@ANI as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
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

		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		Set @UserAction = 'Update Watch List Detail DNI ' +  @DNI + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		RETURN 0;
		
	 	END
	ELSE
	if @count = 0
	  BEGIN
		INSERT INTO [tblAlertPhones] ([PhoneNo],[FacilityID],[Username],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@DNI,@FacilityID,@Username,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);

		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID
			   
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

		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		Set @UserAction = 'Update Watch List Detail PIN ' +  CAST (@PIN as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		
		RETURN 0;
	 END
	ELSE
	if @count = 0
	  BEGIN
		INSERT INTO [tblAlertPINs] ([PIN],[FacilityID],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@PIN,@FacilityID,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);
		--EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@PIN
		Set @UserAction = 'Update Watch List Detail PIN ' +  CAST (@PIN as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		RETURN 1;
	 END
	else
	Begin
		RETURN -1;
	End
end

If @watchByID = 4
Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertInmates] WHERE WatchListDetailID =  @WatchListDetailID 
	IF @count > 0 --check to see if Inmate ID is already in the watchlist
		BEGIN
		
		Update [tblAlertInmates]  set
	             
               	 [AlertEmails]=@AlertEmails,
                	[AlertCellPhones]=@AlertCellPhones,
		[AlertRegPhone]=@AlertRegPhone,
		[HourlyFreq]=@HourlyFreq,
		[DailyFreq]=@DailyFreq,
		[WeeklyFreq]=@WeeklyFreq,
		[MonthlyFreq]=@MonthlyFreq,
		[AlertMessage]=@AlertMessage

		where WatchListDetailID = @WatchListDetailID

		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		Set @UserAction = 'Update Watch List Detail Inmate ID ' +  CAST (@PIN as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		
		RETURN 0;
	 END
	ELSE
	if @count = 0
	  BEGIN
		INSERT INTO [tblAlertInmates] ([InmateId],[FacilityID],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@InmateId,@FacilityID,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);
		--EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@PIN
		Set @UserAction = 'Update Watch List Detail PIN ' +  CAST (@PIN as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		RETURN 1;
	 END
	else
	Begin
		RETURN -1;
	End
end	  
else
If @watchByID = 5
	begin
		
		
			   
		RETURN 0;
	 END
else
If @watchByID = 6
	  BEGIN
		
		
			   
		RETURN 0;
	 END
else
If @watchByID = 7
	  Begin
	SELECT @count = COUNT(WatchListDetailID) FROM [tblAlertEmailInmates] WHERE WatchListDetailID =  @WatchListDetailID 
	IF @count > 0 --check to see if Inmate ID is already in the watchlist
		BEGIN
		
		Update [tblAlertEmailInmates]  set
	             
               	 [AlertEmails]=@AlertEmails,
                	[AlertCellPhones]=@AlertCellPhones,
		[AlertRegPhone]=@AlertRegPhone,
		[HourlyFreq]=@HourlyFreq,
		[DailyFreq]=@DailyFreq,
		[WeeklyFreq]=@WeeklyFreq,
		[MonthlyFreq]=@MonthlyFreq,
		[AlertMessage]=@AlertMessage

		where WatchListDetailID = @WatchListDetailID

		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		Set @UserAction = 'Update Watch List Detail Email Inmate ID ' +  CAST (@PIN as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		
		RETURN 0;
	 END
	ELSE
	if @count = 0
	  BEGIN
		INSERT INTO [tblAlertEmailInmates] ([EmailInmateId],[FacilityID],[AlertEmails],[AlertCellPhones],[AlertRegPhone],[HourlyFreq],[DailyFreq],[WeeklyFreq],[MonthlyFreq],[WatchListDetailID],[AlertMessage])
			   VALUES (@InmateId,@FacilityID,@AlertEmails,@AlertCellPhones,@AlertRegPhone,@HourlyFreq,@DailyFreq,@WeeklyFreq,@MonthlyFreq,@WatchListDetailID,@AlertMessage);
		--EXEC  INSERT_ActivityLogs1   @FacilityID,12, 0,	@Username,'',@PIN
		Set @UserAction = 'Update Watch List Detail Inmate ID ' +  CAST (@PIN as varchar(15)) + ' from ' + @WatchListName 
		EXEC  INSERT_ActivityLogs5   @FacilityID,12, @UserAction, @Username, @UserIP
		Update [tblWatchList]  set

		[ThirdPartyAlert]=@ThirdPartyAlert,
		[LocationTrace]=@LocationTrace

		where [ID] = @WatchListDetailID

		RETURN 1;
	 END
	else
	Begin
		RETURN -1;
	End
end	  

