
CREATE PROCEDURE [dbo].[UPDATE_InmateByPIN3]
(
	@PIN Varchar(12),
	@InmateID Varchar(12),
	@LastName varchar(25),
	@FirstName varchar(25),
	@MidName varchar(25),
	@Status tinyint,
	@DNIRestrict bit,
	@DateTimeRestrict bit,
	@AlertEmail varchar(25),
	@AlertCellPhones varchar(100),
	@AlertPhone char(10),
	@MaxCallTime smallint,
	@DNILimit tinyint,
	@FacilityId int,
	@UserName varchar(20),
	@HourlyFreq tinyint,
	@DailyFreq tinyint,
	@WeeklyFreq tinyint,
	@MonthlyFreq tinyint,
	@MaxCallPerHour tinyint,
	@MaxCallPerDay tinyint,
	@MaxCallPerWeek tinyint,
	@MaxCallPerMonth tinyint,
	@TTY bit,
	@DebitCardOpt bit
)
AS
	
SET NOCOUNT OFF;

BEGIN
		UPDATE [tblInmate] SET [InmateID] = @InmateID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, 
				[Status] = @Status, [DNIRestrict] = @DNIRestrict, [DateTimeRestrict] = @DateTimeRestrict,
				[AlertEmail] = @AlertEmail, [AlertCellPhones] = @AlertCellPhones, [AlertPhone] = @AlertPhone,
				[MaxCallTime] = @MaxCallTime, [DNILimit] = @DNILimit, [UserName] = @UserName, 
				[ModifyDate] = getdate(), [HourlyFreq] = @HourlyFreq, [DailyFreq] = @DailyFreq, [WeeklyFreq] = @WeeklyFreq, [MonthlyFreq] = @MonthlyFreq,
				[MaxCallPerHour] = @MaxCallPerHour, [MaxCallPerDay] = @MaxCallPerDay, [MaxCallPerWeek] = @MaxCallPerWeek, [MaxCallPerMonth] = @MaxCallPerMonth, [TTY] = @TTY , DebitCardOpt = @DebitCardOpt 
		WHERE (PIN = @PIN AND [FacilityId] = @FacilityId)

		if(@Status >1)
		 begin
			Update tblDebit  Set status =  2 where InmateID = @InmateID and   [FacilityId] = @FacilityId
		 end
		else 
		  begin
			Update tblDebit  Set status =  1  where InmateID = @InmateID and   [FacilityId] = @FacilityId
		 end
		EXEC  INSERT_ActivityLogs1   @FacilityID,10, 0,	@userName,'', @PIN

		RETURN 0;
END
