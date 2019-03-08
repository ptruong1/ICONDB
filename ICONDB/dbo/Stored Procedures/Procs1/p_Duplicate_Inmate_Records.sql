-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Duplicate_Inmate_Records]
(
	
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
	@InmateNote varchar(200),
	@MinLength		tinyint
	
)
AS
	
SET NOCOUNT OFF;
Declare @PIN varchar(12), @i int, @ActiveDate smalldatetime;

IF (SELECT Count( InmateID)  FROM tblInmate WHERE FacilityID = @FacilityId  and InmateID = @InmateID)  >0
	RETURN -1;
ELSE
	BEGIN
		If( @FacilityId =607   )
		 Begin
			exec p_create_new_PIN1 4,   @PIN  OUTPUT;			
			SET @PIN =@InmateID + @PIN;
		 End
		Else If( @FacilityId =670   )
		 Begin
			exec p_create_new_PIN1 6,   @PIN  OUTPUT;			
			
		 End
		Else
		 begin	
			If( @inmateID is null  or  @inmateID =''   )
			 Begin
				exec p_create_new_PIN1 @MinLength,   @PIN  OUTPUT;
				set @i  = 1;
				while @i = 1
				 Begin
					select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID =  @FacilityId;
					If  (@i > 0 ) 
					 Begin
						exec p_create_new_PIN1 @MinLength,   @PIN  OUTPUT;
						SET @i = 1;
					 end
				 end 
				SET  @InmateID =@PIN;
			 End
			Else
			 Begin
				SET  @PIN  =@InmateID;
				--IF( @FacilityId = 1 or   @FacilityId = 520) 
				IF (select count(*) from leg_Icon.dbo.tblFacilityOption where FacilityID =@FacilityId  and AutoPin =1) =1
				 Begin
					exec p_create_new_PIN1  5,   @PIN  OUTPUT;
					set @i  = 1;
					while @i = 1
					 Begin
						select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID =  @FacilityId;
						If  (@i > 0 ) 
						 Begin
							exec p_create_new_PIN1  5,   @PIN  OUTPUT;
							SET @i = 1;
						 end
					 end 
		
				 End
			End 
		End
		
		insert into [tblInmate] ([InmateID], [LastName] , [FirstName], [MidName] , 
				[Status] , [DNIRestrict], [DateTimeRestrict] ,
				[AlertEmail] , [AlertCellPhones] , [AlertPhone] ,
				[MaxCallTime] , [DNILimit] , [UserName] , 
				[ModifyDate] , [HourlyFreq] , [DailyFreq] , [WeeklyFreq] , [MonthlyFreq] ,
				[MaxCallPerHour], [MaxCallPerDay] , [MaxCallPerWeek] , [MaxCallPerMonth] , [TTY] , DebitCardOpt ,
				[NameRecorded], [StartDate],[EndDate], BlockPeriodOfTime, PANNotallow, NotAllowLimit,
				[AssignToDivision],
				[AssignToLocation],
				[AssignToStation],	
				[BioRegister], 
				[CustodialOpt],
				[DOB],
				[SEX],
				[RaceID],
				[AdminNote],
				[InmateNote],  
				[FacilityID],
				[PIN] )
				
		Values (  @InmateID, @LastName,  @FirstName,  @MidName, 
				 @Status,  @DNIRestrict,  @DateTimeRestrict,
				@AlertEmail, @AlertCellPhones,  @AlertPhone,
				 @MaxCallTime,  @DNILimit,  @UserName, 
				 getdate(),  @HourlyFreq,  @DailyFreq,  @WeeklyFreq,  @MonthlyFreq,
				 @MaxCallPerHour,  @MaxCallPerDay,  @MaxCallPerWeek,  @MaxCallPerMonth,  @TTY ,  @DebitCardOpt,
				0, @StartDate, @EndDate, @BlockPeriodOfTime, @PANNotAllow, @NotAllowLimit,
				@AssignToDivision,
				@AssignToLocation,
				@AssignToStation,	
				0, 
				@CustodialOpt,
				@DOB,
				@SEX,
				@RaceID,
				@AdminNote,
				@InmateNote,
				@FacilityID, 
				@PIN ) 		
		
	
		EXEC  INSERT_ActivityLogs1   @FacilityID,10, 0,	@userName,'', @PIN
		RETURN 0;
END

