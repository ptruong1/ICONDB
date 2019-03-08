-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_InmateByInmateID_102314]
(
	@PIN Varchar(12),
	@InmateID Varchar(12),
	@OrigInmateID Varchar(12),
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
	@DebitCardOpt	bit,
	@NameRecorded bit,
	@BlockPeriodOfTime bit,
	@StartDate datetime,
	@EndDate datetime,
	@PANNotAllow bit,
	@NotAllowLimit tinyint,
	@AssignToDivision int,
	@AssignToLocation int,
	@AssignToStation int,
	@BioRegister bit,
	@CustodialOpt bit,
	@DOB varchar(12),
	@SEX varchar(1),
	@RaceID int,
	@AdminNote varchar(150),
	@InmateNote varchar(200)
	
)
AS
	
SET NOCOUNT OFF;

BEGIN
		UPDATE [tblInmate] SET [InmateID] = @OrigInmateID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, 
				[Status] = @Status, [DNIRestrict] = @DNIRestrict, [DateTimeRestrict] = @DateTimeRestrict,
				[AlertEmail] = @AlertEmail, [AlertCellPhones] = @AlertCellPhones, [AlertPhone] = @AlertPhone,
				[MaxCallTime] = @MaxCallTime, [DNILimit] = @DNILimit, [UserName] = @UserName, 
				[ModifyDate] = getdate(), [HourlyFreq] = @HourlyFreq, [DailyFreq] = @DailyFreq, [WeeklyFreq] = @WeeklyFreq, [MonthlyFreq] = @MonthlyFreq,
				[MaxCallPerHour] = @MaxCallPerHour, [MaxCallPerDay] = @MaxCallPerDay, [MaxCallPerWeek] = @MaxCallPerWeek, [MaxCallPerMonth] = @MaxCallPerMonth, [TTY] = @TTY , DebitCardOpt = @DebitCardOpt,
				[NameRecorded]=@NameRecorded, [StartDate]=@StartDate,[EndDate]=@EndDate, BlockPeriodOfTime=@BlockPeriodOfTime, PANNotallow=@PANNotAllow, NotAllowLimit=@NotAllowLimit,
				[AssignToDivision]=@AssignToDivision,
				[AssignToLocation]=@AssignToLocation,
				[AssignToStation]=@AssignToStation,	
				[BioRegister]=@BioRegister, 
				[CustodialOpt]=@CustodialOpt,
				[DOB]=@DOB,
				[SEX]=@SEX,
				[RaceID]=@RaceID,
				[AdminNote]=@AdminNote,
				[InmateNote]=@InmateNote  
				
				
		WHERE (InmateID = @OrigInmateId AND [FacilityId] = @FacilityId)

		if(@Status >1)
		 begin
			Update tblDebit  Set status =  2 where InmateID = @OrigInmateID and   [FacilityId] = @FacilityId
		 end
		else 
		  begin
			Update tblDebit  Set status =  1  where InmateID = @OrigInmateID and   [FacilityId] = @FacilityId
		 end
	-----------
		If (@DNIRestrict = 0)
		Begin
		     Delete from tblPhones WHERE (PIN = @PIN AND [FacilityId] = @FacilityId)
		End
		
		If (@PANNotAllow = 0)
		Begin 
		   Delete from tblBlockedPhonesByPIN WHERE (PIN = @PIN AND [FacilityId] = @FacilityId)
		End
	------------
		EXEC  INSERT_ActivityLogs1   @FacilityID,10, 0,	@userName,'', @PIN
		RETURN 0;
END

