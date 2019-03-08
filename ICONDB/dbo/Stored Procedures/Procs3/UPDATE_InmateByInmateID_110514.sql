-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_InmateByInmateID_110514]
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
BEGIN	
SET NOCOUNT OFF;

	Declare @prePIN Varchar(12),
	@preLastName varchar(25),
	@preFirstName varchar(25),
	@preMidName varchar(25),
	@preStatus tinyint,
	@preDNIRestrict bit,
	@preDateTimeRestrict bit,
	@preAlertEmail varchar(25),
	@preAlertCellPhones varchar(100),
	@preAlertPhone char(10),
	@preMaxCallTime smallint,
	@preDNILimit tinyint,
	@preFacilityId int,
	@preUserName varchar(20),
	@preHourlyFreq tinyint,
	@preDailyFreq tinyint,
	@preWeeklyFreq tinyint,
	@preMonthlyFreq tinyint,
	@preMaxCallPerHour tinyint,
	@preMaxCallPerDay tinyint,
	@preMaxCallPerWeek tinyint,
	@preMaxCallPerMonth tinyint,
	@preTTY bit,
	@preDebitCardOpt	bit,
	@preNameRecorded bit,
	@preBlockPeriodOfTime bit,
	@preStartDate datetime,
	@preEndDate datetime,
	@prePANNotAllow bit,
	@preNotAllowLimit tinyint,
	@preAssignToDivision int,
	@preAssignToLocation int,
	@preAssignToStation int,
	@preBioRegister bit,
	@preCustodialOpt bit,
	@preDOB varchar(12),
	@preSEX varchar(1),
	@preRaceID int,
	@preAdminNote varchar(150),
	@preInmateNote varchar(200), @WhatEdit varchar(500) ,@ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

	Select      @preLastName=isnull([LastName],''), 
				@preFirstName=isnull([FirstName],''),
				@preMidName= isnull([MidName],''), 
				@preStatus=[Status], 
				@preDNIRestrict=isnull([DNIRestrict],0), 
				@preDateTimeRestrict =isnull([DateTimeRestrict],0),
				@preAlertEmail =isnull([AlertEmail],''), 
				@preAlertCellPhones =isnull( AlertCellPhones,''), 
				@preAlertPhone=isnull([AlertPhone],''),
				@preMaxCallTime=isnull([MaxCallTime],0), 
				@preDNILimit=isnull([DNILimit],0), 
				@preUserName=isnull(UserName,''), 
				@preHourlyFreq=isnull([HourlyFreq],0), 
				@preDailyFreq=isnull([DailyFreq],0),
				@preWeeklyFreq=isnull([WeeklyFreq],0), 
				@preMonthlyFreq=isnull([MonthlyFreq],0),
				@preMaxCallPerHour=isnull([MaxCallPerHour],0), 
				@preMaxCallPerDay=isnull([MaxCallPerDay],0), 
				@preMaxCallPerWeek=isnull([MaxCallPerWeek],0), 
				@preMaxCallPerMonth=isnull([MaxCallPerMonth],0), 
				@preTTY=isnull([TTY],0) , 
				@preDebitCardOpt=isnull(DebitCardOpt,0),
				@preNameRecorded=isnull([NameRecorded],0),
				@preStartDate= [StartDate],
				@preEndDate=[EndDate], 
				@preBlockPeriodOfTime=isnull(BlockPeriodOfTime,0), 
				@prePANNotAllow=isnull(PANNotallow,0), 
				@preNotAllowLimit=isnull(NotAllowLimit,0),
				@preAssignToDivision=isnull([AssignToDivision],0),
				@preAssignToLocation=isnull([AssignToLocation],0),
				@preAssignToStation=isnull([AssignToStation],0),	
				@preBioRegister=isnull([BioRegister],0), 
				@preCustodialOpt=isnull([CustodialOpt],0),
				@preDOB=isnull([DOB],''),
				@preSEX=isnull([SEX],'U'),
				@preRaceID =isnull([RaceID],0),
				@preAdminNote=isnull([AdminNote],''),
				@preInmateNote =isnull([InmateNote],'')
				From tblInmate with(nolock) where FacilityId = @FacilityId and InmateID =@OrigInmateID;
	
		UPDATE  [tblInmate] SET [InmateID] = @OrigInmateID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, 
				[Status] = @Status, [DNIRestrict] = @DNIRestrict, [DateTimeRestrict] = @DateTimeRestrict,
				[AlertEmail] = @AlertEmail, [AlertCellPhones] = @AlertCellPhones, [AlertPhone] = @AlertPhone,
				[MaxCallTime] = @MaxCallTime, [DNILimit] = @DNILimit, [UserName] = @UserName, 
				[ModifyDate] = @ActTime, [HourlyFreq] = @HourlyFreq, [DailyFreq] = @DailyFreq, [WeeklyFreq] = @WeeklyFreq, [MonthlyFreq] = @MonthlyFreq,
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
				
		WHERE (InmateID = @OrigInmateId AND [FacilityId] = @FacilityId and PIN = @PIN) ;

		if(@preStatus=1 and @Status >1)
		 begin
			Update tblDebit  Set status =  2, modifyDate=@ActTime  where InmateID = @OrigInmateID and   [FacilityId] = @FacilityId ;
			if (@Status =2 or @FacilityId =670)
			 begin
				 Delete from tblPhones WHERE (InmateID = @OrigInmateID AND [FacilityId] = @FacilityId) ;
				 Update tblInmate  Set BioRegister =0, NameRecorded =0,DNIRestrict=0,PANNotAllow =0,DateTimeRestrict =0  where InmateID = @OrigInmateID and   [FacilityId] = @FacilityId ;
			 end
			
		 end
		else if(@preStatus >1 and @Status =1)
		  begin
			Update tblDebit  Set status =  1  where InmateID = @OrigInmateID and   [FacilityId] = @FacilityId ;
			Update tblInmate  Set ActiveDate= @ActTime,BioRegister =0, NameRecorded =0,DNIRestrict=0,PANNotAllow =0,DateTimeRestrict =0  where InmateID = @OrigInmateID and   [FacilityId] = @FacilityId ;
		 end
	-----------
	
		If (@prePANNotAllow=1 and @PANNotAllow = 0)
		Begin 
		   Delete from tblBlockedPhonesByPIN WHERE (PIN = @PIN AND [FacilityId] = @FacilityId)
		End
	----Check all Fields--------
	    SET @WhatEdit ='';
	    if(@preLastName <> @LastName)
			SET @WhatEdit = 'Last Name Changed: ' + @preLastName + '-->' + @LastName ;
		if(@preFirstName <> @FirstName)
			SET @WhatEdit =  @WhatEdit  + '; First Name Changed: ' + @preFirstName + '-->' + @FirstName ;
		if(@preMidName <>@MidName and @MidName is not null )
			SET @WhatEdit =  @WhatEdit  + '; Mid Name Changed:' + @preMidName + '-->' + @MidName ; 
		if (@preStatus <> @Status)
		 begin
			SET @WhatEdit =  @WhatEdit  + '; Status Changed: ' + (select Descipt  from tblInmateStatus with(nolock) where statusID = @preStatus) + '-->' + (select Descipt  from tblInmateStatus with(nolock) where statusID=@status) ; 
		 end
		if (@preDNIRestrict<>@DNIRestrict and @DNIRestrict  is not null)
			SET @WhatEdit =  @WhatEdit  + '; PAN Restrict Changed: ' + (CASE @preDNIRestrict when 0 then 'No' else 'Yes' end) + '-->' + (CASE @DNIRestrict when 0 then 'No' else 'Yes' end) ;  
		if(@preDateTimeRestrict<> @DateTimeRestrict and  @DateTimeRestrict is not null)
			SET @WhatEdit =  @WhatEdit  + '; Date Time Restrict Changed:' + (CASE @preDateTimeRestrict when 0 then 'No' else 'Yes' end) + '-->' + (CASE @DateTimeRestrict when 0 then 'No' else 'Yes' end) ;  
		if(@preAlertEmail <> @AlertEmail and  @AlertEmail is not null)
			SET @WhatEdit =  @WhatEdit  + '; Alert Email Changed:' + @preAlertEmail + '-->' + @AlertEmail ;  
		if(@preAlertCellPhones <>@AlertCellPhones and @AlertCellPhones is not null)
			SET @WhatEdit =  @WhatEdit  + '; Alert Cell Phone Changed: ' + @preAlertCellPhones + '-->' + @AlertCellPhones ;
		if(@preAlertPhone <>@AlertPhone and @AlertPhone is not null)
			SET @WhatEdit =  @WhatEdit  + '; Alert Phone Changed: ' + @preAlertPhone + '-->' + @AlertPhone ;
		if(@preMaxCallTime<>@MaxCallTime and @MaxCallTime is not null )
			SET @WhatEdit =  @WhatEdit  + '; Max Call Time Changed: ' + @preMaxCallTime + '-->' + @MaxCallTime; 
		if(@preDNILimit<>@DNILimit)
			SET @WhatEdit =  @WhatEdit  + '; Max DNI Changed: ' + CAST(@preDNILimit as varchar(2)) + '-->' + cast(@DNILimit as varchar(2)) ;  
		if(@preHourlyFreq <> @HourlyFreq and  @HourlyFreq is not null)
			SET @WhatEdit =  @WhatEdit  + '; HourlyFreq Changed:' + cast(@preHourlyFreq as varchar(2)) + '-->' + cast(@HourlyFreq  as varchar(2));   
		if(@preDailyFreq <> @DailyFreq and @DailyFreq is not null )
			SET @WhatEdit =  @WhatEdit  + '; DailyFreq Changed: ' + cast(@preDailyFreq as varchar(2)) + '-->' + cast(@DailyFreq  as varchar(2));   
		if(@preWeeklyFreq<>@WeeklyFreq and @WeeklyFreq is not null )
			SET @WhatEdit =  @WhatEdit  + '; WeeklyFreq Changed: ' +CAST( @preWeeklyFreq  as varchar(2))+ '-->' + CAST(@WeeklyFreq as varchar(2)) ;    
		if(@preMonthlyFreq<>@MonthlyFreq and @MonthlyFreq is not null)
			SET @WhatEdit =  @WhatEdit  + '; WeeklyFreq Changed: ' + cast(@preWeeklyFreq as  varchar(2)) + '-->' + cast(@WeeklyFreq as  varchar(2)) ;			
		if(@preMaxCallPerHour<>@MaxCallPerHour and @MaxCallPerHour is not null)
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerHour Changed:' + cast(@preMaxCallPerHour as  varchar(2)) + '-->' + cast(@MaxCallPerHour as  varchar(2)) ;
		if(@preMaxCallPerDay<>@MaxCallPerDay and @MaxCallPerDay is not null )
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerDay Changed: ' + CAST( @preMaxCallPerDay as  varchar(2)) + '-->' + cast(@MaxCallPerDay as  varchar(2));
		if(@preMaxCallPerWeek<>@MaxCallPerWeek and @MaxCallPerWeek is not null )
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerWeek Changed: ' + CAST( @preMaxCallPerWeek  as  varchar(2))+ '-->' + cast(@MaxCallPerWeek as  varchar(2)) ;
		if(@preMaxCallPerMonth<>@MaxCallPerMonth and @MaxCallPerMonth is not null )
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerMonth Changed: ' + cast(@preMaxCallPerMonth as  varchar(2)) + '-->' + cast(@MaxCallPerMonth as  varchar(2)) ;
		if(@preTTY<>@TTY and @TTY is not null )
			SET @WhatEdit =  @WhatEdit  + '; TTY Changed:' +(CASE @preTTY when 0 then 'No' else 'Yes' end) + '-->' + (CASE @TTY when 0 then 'No' else 'Yes' end); 
		if(@preNameRecorded<>@NameRecorded and  @NameRecorded is not null)
			SET @WhatEdit =  @WhatEdit  + '; NameRecorded Changed: ' + (CASE @preNameRecorded when 0 then 'No' else 'Yes' end)+ '-->' + (case @NameRecorded  when 0 then 'No' else 'Yes' end); 
		if(@preStartDate<>@StartDate and @StartDate is not null)
			SET @WhatEdit =  @WhatEdit  + '; Suspend StartDate Changed: ' + CAST( @preStartDate as  varchar(2)) + '-->' + cast(@StartDate as  varchar(2)) ; 
		if(@preEndDate<> @EndDate and  @EndDate is not null )
			SET @WhatEdit =  @WhatEdit  + '; Suspend EndDate Changed: ' + CAST( @preEndDate  as  varchar(2))+ '-->' + cast(@EndDate as  varchar(2)) ; 
		If(@preBlockPeriodOfTime<>@BlockPeriodOfTime and @BlockPeriodOfTime is not null)
			SET @WhatEdit =  @WhatEdit  + '; BlockPeriodOfTime Changed: ' + (CASE @preBlockPeriodOfTime when 0 then 'No' else 'Yes' end) + '-->' + (case @BlockPeriodOfTime when 0 then 'No' else 'Yes' end) ; 
		If(@prePANNotAllow<>@PANNotallow and @PANNotallow is not null )
			SET @WhatEdit =  @WhatEdit  + '; PANNotAllow Changed:' + CAST( @prePANNotAllow as  varchar(2))+ '-->' + CAST(@PANNotAllow as  varchar(2)) ;
		if(@preNotAllowLimit<> @NotAllowLimit and @NotAllowLimit is not null )
			SET @WhatEdit =  @WhatEdit  + '; PAN NotAllowLimit Changed: ' + CAST( @preNotAllowLimit as  varchar(2)) + '-->' + cast(@NotAllowLimit as  varchar(2)) ;
		if(@preAssignToDivision<>@AssignToDivision and @AssignToDivision is not null )
			SET @WhatEdit =  @WhatEdit  + '; AssignToDivision Changed: ' + CAST(@preAssignToDivision as  varchar(2))+ '-->' +CAST(@AssignToDivision  as  varchar(2));
		if(@preAssignToLocation<>@AssignToLocation and @AssignToLocation is not null)
			SET @WhatEdit =  @WhatEdit  + '; AssignToLocation Changed: ' + CAST(@preAssignToLocation as  varchar(2)) + '-->' +cast(@AssignToLocation as  varchar(2)) ;
		if(@preAssignToStation<>@AssignToStation and @AssignToStation is not null)
			SET @WhatEdit =  @WhatEdit  + '; AssignToStation Changed: ' +CAST( @preAssignToStation as  varchar(2)) + '-->' + CAST(@AssignToStation  as  varchar(2));	
		if(@preBioRegister<>@BioRegister and @BioRegister is not null)
			SET @WhatEdit =  @WhatEdit  + '; BioRegister Changed: ' + (CASE @preBioRegister when 0 then 'No' else 'Yes' end) + '-->' + (CASE @BioRegister when 0 then 'No' else 'Yes' end) ;
		if(@preCustodialOpt<>@CustodialOpt and @CustodialOpt is not null )
			SET @WhatEdit =  @WhatEdit  + '; CustodialOpt Changed: ' + (CASE @preCustodialOpt when 0 then 'No' else 'Yes' end) + '-->' + (CASE @CustodialOpt when 0 then 'No' else 'Yes' end) ;
		if(@preDOB<>@DOB and @DOB is not null )
			SET @WhatEdit =  @WhatEdit  + '; DOB Changed: ' + @preDOB + '-->' +@DOB ;
		if(@preSEX<>@SEX and @SEX is not null )
			SET @WhatEdit =  @WhatEdit  + '; SEX Changed: ' +( select Descript  from tblsex  where Sex= @preSEX) + '-->' + ( select Descript  from tblsex  where Sex= @SEX) ;
		if(@preRaceID<>@RaceID and @RaceID is not null)
			SET @WhatEdit =  @WhatEdit  + '; Race Changed: ' + ( select Descript from tblRaces where  RaceID = @preRaceID ) + '-->' +( select Descript from tblRaces where  RaceID=@RaceID ) ;
		if(@preAdminNote<>@AdminNote and @AdminNote is not null)
			SET @WhatEdit =  @WhatEdit  + '; AdminNote Changed: ' + @preAdminNote + '-->' +@AdminNote ;
		if(@preInmateNote <>@InmateNote and @InmateNote is not null)
			SET @WhatEdit =  @WhatEdit  + '; InmateNote Changed: ' + @preInmateNote + '-->' +@InmateNote ;
	-----------
		if(@WhatEdit <>'')
		 begin
			SET @WhatEdit ='Edit Inmate: ' + @OrigInmateID  + @WhatEdit ;
			EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,	'',	@InmateID,@WhatEdit
		 end
		RETURN @@error;
END

