CREATE PROCEDURE [dbo].[p_Insert_Inmate_v1]
(
	@InmateID varchar(12),
	@MinLength		tinyint,
	@LastName varchar(25),
	@FirstName varchar(25),
	@MidName varchar(25),
	@Status tinyint,
	@DNIRestrict bit,
	@DateTimeRestrict bit,
	@AlertEmail varchar(100),
	@AlertPhone char(10),
	@AlertCellPhones varchar(100),
	@DNILimit tinyint,
	@FacilityId int,
	@UserName varchar(20),
	@MaxCallTime smallint,
	@HourlyFreq tinyint,
	@DailyFreq tinyint,
	@WeeklyFreq tinyint,
	@MonthlyFreq tinyint,
	@DebitCardOpt	bit,
	@StartDate  smalldatetime,
	@EndDate   smalldatetime,
	@BlockPeriodOfTime bit,
	@PANNotAllow bit,
	@NotAllowLimit tinyint,
	@AssignToDivision int,
	@AssignToLocation int,
	@AssignToStation int,
	@CustodialOpt bit,
	@DOB varchar(12),
	@SEX varchar(1),
	@RaceID int,
	@AdminNote varchar(150),
	@InmateNote varchar(200),
	@UserIP varchar(25),
	@PrimaryLanguage tinyint,
	@InmateOut varchar(12) OUTPUT
)
AS
	SET NOCOUNT OFF;
Declare @PIN varchar(12), @i int, @ActiveDate smalldatetime;
EXEC [p_get_facility_time] @facilityID ,@ActiveDate OUTPUT ;
IF (SELECT Count( InmateID)  FROM tblInmate WHERE FacilityID = @FacilityId  and InmateID = @InmateID)  >0
	RETURN -1;
ELSE
	BEGIN
		If( @FacilityId in (607 ,689)  )
		 Begin
			exec p_create_new_PIN1 4,   @PIN  OUTPUT;			
			SET @PIN =@InmateID + @PIN;
		 End
		Else If( @FacilityId in (670) )
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
					if(@FacilityId =695)
						Set @MinLength =4;
					else
						Set @MinLength =5;
					exec p_create_new_PIN1   @MinLength,   @PIN  OUTPUT;
					set @i  = 1;
					while @i = 1
					 Begin
						select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID =  @FacilityId;
						If  (@i > 0 ) 
						 Begin
							exec p_create_new_PIN1   @MinLength,   @PIN  OUTPUT;
							SET @i = 1;
						 end
					 end 
		
				 End
			End 
		End
		INSERT INTO [tblInmate] ([InmateID], [LastName], [FirstName], [MidName], 
					[Status], [DNIRestrict], [DateTimeRestrict], [AlertEmail], [AlertPhone], 
					[AlertCellPhones], [DNILimit], [FacilityId], [UserName], PIN,
					[MaxCallTime],[HourlyFreq], [DailyFreq], [WeeklyFreq], [MonthlyFreq], debitCardOpt, StartDate, EndDate,BlockPeriodOfTime, PANNotAllow, NotAllowLimit,
					AssignToDivision, AssignToLocation, AssignToStation, CustodialOpt, DOB, SEX, RaceID, AdminNote, InmateNote,ActiveDate, PrimaryLanguage) 
				VALUES ( @InmateID, @LastName, @FirstName, @MidName, 
						@Status, @DNIRestrict,	 @DateTimeRestrict, @AlertEmail, @AlertPhone,
						 @AlertCellPhones, @DNILimit, @FacilityId, @UserName, @PIN,
						@MaxCallTime, @HourlyFreq, @DailyFreq, @WeeklyFreq, @MonthlyFreq, @DebitCardOpt, @StartDate, @EndDate,@BlockPeriodOfTime, @PANNotAllow, @NotAllowLimit,
						@AssignToDivision, @AssignToLocation, @AssignToStation, @CustodialOpt, @DOB, @SEX, @RaceID, @AdminNote, @InmateNote,@ActiveDate, @PrimaryLanguage );


		SET @InmateOut  = @InmateID
		
		if ( select count(*) from tblfacility with(nolock) where facilityID = @facilityID  and AgentID =1169) > 0
		  Begin
			
			EXEC  INSERT_DebitAccount2	@InmateID,	@FacilityID ,	@ActiveDate , '1/1/2020',	0,	0,1,'',	@UserName ,	'0',	1;

		  End
		--EXEC  INSERT_ActivityLogs1   @FacilityID,10, 0,	@userName,'', @PIN;
		declare @UserAction varchar(100)
		SET  @UserAction =  'Add New Inmate: ' +  @InmateID + ' ;Last Name: ' + @LastName +  '; Firs Name:' + @FirstName ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActiveDate  ,0,@UserName ,@UserIP, @InmateID,@UserAction ;  
		RETURN 0;
	END
