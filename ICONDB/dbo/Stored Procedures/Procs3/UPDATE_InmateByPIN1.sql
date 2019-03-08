
CREATE PROCEDURE [dbo].[UPDATE_InmateByPIN1]
(
	@PIN bigint,
	@InmateID bigint,
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
	@MaxCallPerMonth tinyint
)
AS
	
SET NOCOUNT OFF;
IF @InmateID in (SELECT InmateID FROM tblInmate WHERE FacilityID = @FacilityId AND PIN <> @PIN)
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		UPDATE [tblInmate] SET [InmateID] = @InmateID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, 
				[Status] = @Status, [DNIRestrict] = @DNIRestrict, [DateTimeRestrict] = @DateTimeRestrict,
				[AlertEmail] = @AlertEmail, [AlertCellPhones] = @AlertCellPhones, [AlertPhone] = @AlertPhone,
				[MaxCallTime] = @MaxCallTime, [DNILimit] = @DNILimit, [UserName] = @UserName, 
				[ModifyDate] = getdate(), [HourlyFreq] = @HourlyFreq, [DailyFreq] = @DailyFreq, [WeeklyFreq] = @WeeklyFreq, [MonthlyFreq] = @MonthlyFreq,
				[MaxCallPerHour] = @MaxCallPerHour, [MaxCallPerDay] = @MaxCallPerDay, [MaxCallPerWeek] = @MaxCallPerWeek, [MaxCallPerMonth] = @MaxCallPerMonth
		WHERE (PIN = @PIN AND [FacilityId] = @FacilityId)
		RETURN 0;
	END

