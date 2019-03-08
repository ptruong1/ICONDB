

CREATE PROCEDURE [dbo].[INSERT_Inmate_Old]
(
	@InmateID bigint,
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
	@MonthlyFreq tinyint
)
AS
	SET NOCOUNT OFF;
Declare @PIN varchar(12), @i int

IF (SELECT Count( InmateID)  FROM tblInmate WHERE FacilityID = @FacilityId  and InmateID = @InmateID)  >0
	RETURN -1;
ELSE
	BEGIN
			
		If( @inmateID > 0)
			SET @PIN = CAST (@inmateID as varchar(12))
		Else
		 Begin
			exec p_create_new_PIN  @PIN  OUTPUT
			set @i  = 1
			while @i = 1
			Begin
				select  @i = count(*) from tblInmate where PIN = @PIN  and  FacilityID =  @FacilityId
				If  (@i > 0 ) 
				 Begin
					exec p_create_new_PIN  @PIN  OUTPUT
					SET @i = 1
				 end
			end 
		 End
		INSERT INTO [tblInmate] ([InmateID], [LastName], [FirstName], [MidName], 
					[Status], [DNIRestrict], [DateTimeRestrict], [AlertEmail], [AlertPhone], 
					[AlertCellPhones], [DNILimit], [FacilityId], [UserName], PIN,
					[MaxCallTime],[HourlyFreq], [DailyFreq], [WeeklyFreq], [MonthlyFreq]) 
				VALUES ( @PIN, @LastName, @FirstName, @MidName, 
						@Status, @DNIRestrict,	 @DateTimeRestrict, @AlertEmail, @AlertPhone,
						 @AlertCellPhones, @DNILimit, @FacilityId, @UserName, @PIN,
						@MaxCallTime, @HourlyFreq, @DailyFreq, @WeeklyFreq, @MonthlyFreq);
	
		RETURN 0;
	END

