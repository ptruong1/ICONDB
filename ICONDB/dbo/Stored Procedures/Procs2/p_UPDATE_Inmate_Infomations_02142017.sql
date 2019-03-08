-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_UPDATE_Inmate_Infomations_02142017]
(
	@PIN Varchar(12),
	@InmateID Varchar(12),
	@OrigInmateID Varchar(12),
	@LastName varchar(25),
	@FirstName varchar(25),
	@MidName varchar(25),
	@Status tinyint,
	@AlertEmail varchar(25),
	@AlertCellPhones varchar(100),
	@AlertPhone char(10),
	@FacilityId int,
	@UserName varchar(20),
	@HourlyFreq tinyint,
	@DailyFreq tinyint,
	@WeeklyFreq tinyint,
	@MonthlyFreq tinyint,
	@TTY bit,
	@DebitCardOpt	bit,
	@NameRecorded bit,
	@BioRegister bit,
	@CustodialOpt bit,
	@DOB varchar(12),
	@SEX varchar(1),
	@RaceID int,
	@UserIP varchar(25),
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
	
	@preAlertEmail varchar(25),
	@preAlertCellPhones varchar(100),
	@preAlertPhone char(10),
	
	@preFacilityId int,
	@preUserName varchar(20),
	@preHourlyFreq tinyint,
	@preDailyFreq tinyint,
	@preWeeklyFreq tinyint,
	@preMonthlyFreq tinyint,
	@preTTY bit,
	@preDebitCardOpt	bit,
	@preNameRecorded bit,
	
	@preBioRegister bit,
	@preCustodialOpt bit,
	@preDOB varchar(12),
	@preSEX varchar(1),
	@preRaceID int,
	@preInmateNote varchar(200), @WhatEdit varchar(500) ,@ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

	Select      @preLastName=isnull([LastName],''), 
				@preFirstName=isnull([FirstName],''),
				@preMidName= isnull([MidName],''), 
				@preStatus=[Status], 
				 
				
				@preAlertEmail =isnull([AlertEmail],''), 
				@preAlertCellPhones =isnull( AlertCellPhones,''), 
				@preAlertPhone=isnull([AlertPhone],''),
				
				@preUserName=isnull(UserName,''), 
				@preHourlyFreq=isnull([HourlyFreq],0), 
				@preDailyFreq=isnull([DailyFreq],0),
				@preWeeklyFreq=isnull([WeeklyFreq],0), 
				@preMonthlyFreq=isnull([MonthlyFreq],0),
				@preTTY=isnull([TTY],0) , 
				@preDebitCardOpt=isnull(DebitCardOpt,0),
				@preNameRecorded=isnull([NameRecorded],0),
				
				@preBioRegister=isnull([BioRegister],0), 
				@preCustodialOpt=isnull([CustodialOpt],0),
				@preDOB=isnull([DOB],''),
				@preSEX=isnull([SEX],'U'),
				@preRaceID =isnull([RaceID],0),
				
				@preInmateNote =isnull([InmateNote],'')
				From tblInmate with(nolock) where FacilityId = @FacilityId and InmateID =@OrigInmateID;
	
		UPDATE  [tblInmate] SET [InmateID] = @OrigInmateID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName, 
				[Status] = @Status, 
				[AlertEmail] = @AlertEmail, [AlertCellPhones] = @AlertCellPhones, [AlertPhone] = @AlertPhone,
				[ModifyDate] = @ActTime, [HourlyFreq] = @HourlyFreq, [DailyFreq] = @DailyFreq, [WeeklyFreq] = @WeeklyFreq, [MonthlyFreq] = @MonthlyFreq,
				[UserName] = @UserName, 
				[TTY] = @TTY , DebitCardOpt = @DebitCardOpt,
				[NameRecorded]=@NameRecorded, 
				
				[BioRegister]=@BioRegister, 
				[CustodialOpt]=@CustodialOpt,
				[DOB]=@DOB,
				[SEX]=@SEX,
				[RaceID]=@RaceID,
				
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
		
		if(@preAlertEmail <> @AlertEmail and  @AlertEmail is not null)
			SET @WhatEdit =  @WhatEdit  + '; Alert Email Changed:' + @preAlertEmail + '-->' + @AlertEmail ;  
		if(@preAlertCellPhones <>@AlertCellPhones and @AlertCellPhones is not null)
			SET @WhatEdit =  @WhatEdit  + '; Alert Cell Phone Changed: ' + @preAlertCellPhones + '-->' + @AlertCellPhones ;
		if(@preAlertPhone <>@AlertPhone and @AlertPhone is not null)
			SET @WhatEdit =  @WhatEdit  + '; Alert Phone Changed: ' + @preAlertPhone + '-->' + @AlertPhone ;
		 if(@preHourlyFreq <> @HourlyFreq and  @HourlyFreq is not null)
			SET @WhatEdit =  @WhatEdit  + '; HourlyFreq Changed:' + cast(@preHourlyFreq as varchar(2)) + '-->' + cast(@HourlyFreq  as varchar(2));   
		if(@preDailyFreq <> @DailyFreq and @DailyFreq is not null )
			SET @WhatEdit =  @WhatEdit  + '; DailyFreq Changed: ' + cast(@preDailyFreq as varchar(2)) + '-->' + cast(@DailyFreq  as varchar(2));   
		if(@preWeeklyFreq<>@WeeklyFreq and @WeeklyFreq is not null )
			SET @WhatEdit =  @WhatEdit  + '; WeeklyFreq Changed: ' +CAST( @preWeeklyFreq  as varchar(2))+ '-->' + CAST(@WeeklyFreq as varchar(2)) ;    
		if(@preMonthlyFreq<>@MonthlyFreq and @MonthlyFreq is not null)
			SET @WhatEdit =  @WhatEdit  + '; WeeklyFreq Changed: ' + cast(@preWeeklyFreq as  varchar(2)) + '-->' + cast(@WeeklyFreq as  varchar(2)) ;		
		if(@preTTY<>@TTY and @TTY is not null )
			SET @WhatEdit =  @WhatEdit  + '; TTY Changed:' +(CASE @preTTY when 0 then 'No' else 'Yes' end) + '-->' + (CASE @TTY when 0 then 'No' else 'Yes' end); 
		if(@preNameRecorded<>@NameRecorded and  @NameRecorded is not null)
			SET @WhatEdit =  @WhatEdit  + '; NameRecorded Changed: ' + (CASE @preNameRecorded when 0 then 'No' else 'Yes' end)+ '-->' + (case @NameRecorded  when 0 then 'No' else 'Yes' end); 
		
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
		
		if(@preInmateNote <>@InmateNote and @InmateNote is not null)
			SET @WhatEdit =  @WhatEdit  + '; InmateNote Changed: ' + @preInmateNote + '-->' +@InmateNote ;
	-----------
		if(@WhatEdit <>'')
		 begin
			SET @WhatEdit ='Edit Inmate: ' + @OrigInmateID  + @WhatEdit ;
			EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,	@UserIP,	@InmateID,@WhatEdit
		 end
		RETURN @@error;
END

