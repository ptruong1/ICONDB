-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_UPDATE_Inmate_Phone_Configuration_11092017]
(
	@PIN Varchar(12),
	@InmateID Varchar(12),
	
	@DNIRestrict bit,
	@DateTimeRestrict bit,
	@MaxCallTime smallint,
	@DNILimit tinyint,
	@FacilityId int,
	@UserName varchar(20),
	
	@MaxCallPerHour tinyint,
	@MaxCallPerDay tinyint,
	@MaxCallPerWeek tinyint,
	@MaxCallPerMonth tinyint,
	
	
	@BlockPeriodOfTime bit,
	@StartDate datetime,
	@EndDate datetime,
	@PANNotAllow bit,
	@NotAllowLimit tinyint,
	@AssignToDivision int,
	@AssignToLocation int,
	@AssignToStation int,
	@FreeCallRemain tinyint,
	@UserIP varchar(25),
	@AdminNote varchar(150)
	
	
)
AS
BEGIN	
SET NOCOUNT OFF;
	Declare @prePIN Varchar(12),
	
	
	@preDNIRestrict bit,
	@preDateTimeRestrict bit,
	
	@preMaxCallTime smallint,
	@preDNILimit tinyint,
	@preFacilityId int,
	@preUserName varchar(20),
	
	@preMaxCallPerHour tinyint,
	@preMaxCallPerDay tinyint,
	@preMaxCallPerWeek tinyint,
	@preMaxCallPerMonth tinyint,
	
	@preBlockPeriodOfTime bit,
	@preStartDate datetime,
	@preEndDate datetime,
	@prePANNotAllow bit,
	@preNotAllowLimit tinyint,
	@preAssignToDivision int,
	@preAssignToLocation int,
	@preAssignToStation int,
	@PreFreeCallRemain tinyint,
	@preAdminNote varchar(150),
	
	@WhatEdit varchar(500) ,
	@ActTime datetime;

	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

	Select     
				
				@preDNIRestrict=isnull([DNIRestrict],0), 
				@preDateTimeRestrict =isnull([DateTimeRestrict],0),
				
				@preMaxCallTime=isnull([MaxCallTime],0), 
				@preDNILimit=isnull([DNILimit],0), 
				@preUserName=isnull(UserName,''), 
				
				@preMaxCallPerHour=isnull([MaxCallPerHour],0), 
				@preMaxCallPerDay=isnull([MaxCallPerDay],0), 
				@preMaxCallPerWeek=isnull([MaxCallPerWeek],0), 
				@preMaxCallPerMonth=isnull([MaxCallPerMonth],0), 
				
				@preStartDate= [StartDate],
				@preEndDate=[EndDate], 
				@preBlockPeriodOfTime=isnull(BlockPeriodOfTime,0), 
				@prePANNotAllow=isnull(PANNotallow,0), 
				@preNotAllowLimit=isnull(NotAllowLimit,0),
				@preAssignToDivision=isnull([AssignToDivision],0),
				@preAssignToLocation=isnull([AssignToLocation],0),
				@preAssignToStation=isnull([AssignToStation],0),	
				@PreFreeCallRemain =isnull([FreeCallRemain],0),
				@preAdminNote=isnull([AdminNote],'')
				
				From tblInmate with(nolock) where FacilityId = @FacilityId and InmateID =@InmateID;
	
		UPDATE  [tblInmate] SET  
				[DNIRestrict] = @DNIRestrict, [DateTimeRestrict] = @DateTimeRestrict,
				[MaxCallTime] =  @MaxCallTime , 
				--[MaxCallTime] =  CAST(@maxTime AS SMALLINT), 
				[DNILimit] = @DNILimit, [UserName] = @UserName, 
				[ModifyDate] = @ActTime, 
				[MaxCallPerHour] = @MaxCallPerHour, [MaxCallPerDay] = @MaxCallPerDay, [MaxCallPerWeek] = @MaxCallPerWeek, [MaxCallPerMonth] = @MaxCallPerMonth, 
				[StartDate]=@StartDate,[EndDate]=@EndDate, BlockPeriodOfTime=@BlockPeriodOfTime, PANNotallow=@PANNotAllow, NotAllowLimit=@NotAllowLimit,
				[AssignToDivision]=@AssignToDivision,
				[AssignToLocation]=@AssignToLocation,
				[AssignToStation]=@AssignToStation,	
				[FreeCallRemain] =@Freecallremain
				
							
				
		WHERE (InmateID = @InmateId AND [FacilityId] = @FacilityId and PIN = @PIN) ;
		
		------Insert Phone note
		if (@AdminNote <>'')
		begin
			Declare @return_value int, @nextID int, @ID int, @tblInmateNote nvarchar(32) ;
			EXEC	@return_value = p_create_nextID 'tblInmateNote', @nextID   OUTPUT
			set		@ID = @nextID	;
			INSERT INTO tblInmateNote ([NoteID],[NoteTypeID],[FacilityID] ,[InmateID], [Note], [InputDate], [UserName])
			 VALUES (@ID ,2,@FacilityId, @InmateID, @AdminNote, getdate(), @UserName);
		end

			-----------
	-------------Insert to tblFreeCallRequest
			if(@PreFreeCallRemain<>@FreeCallRemain and @FreeCallRemain is not null)
			begin
				INSERT INTO tblFreeCallRequest ([FacilityID],[InmateID],[FreeCallNo]  ,[RequestBy] ,[RequestNote],[RequestDate], [FreeCallRemain])
				VALUES (@FacilityId, @InmateID,@FreeCallRemain, @UserName, @AdminNote, getdate(), @PreFreeCallRemain);
		     
			end
			
		If (@prePANNotAllow=1 and @PANNotAllow = 0)
		Begin 
		   Delete from tblBlockedPhonesByPIN WHERE (PIN = @PIN AND [FacilityId] = @FacilityId)
		End
	----Check all Fields--------
	    SET @WhatEdit ='';
	    
		
		if (@preDNIRestrict<>@DNIRestrict and @DNIRestrict  is not null)
			SET @WhatEdit =  @WhatEdit  + '; PAN Restrict Changed: ' + (CASE @preDNIRestrict when 0 then 'No' else 'Yes' end) + '-->' + (CASE @DNIRestrict when 0 then 'No' else 'Yes' end) ;  
		if(@preDateTimeRestrict<> @DateTimeRestrict and  @DateTimeRestrict is not null)
			SET @WhatEdit =  @WhatEdit  + '; Date Time Restrict Changed:' + (CASE @preDateTimeRestrict when 0 then 'No' else 'Yes' end) + '-->' + (CASE @DateTimeRestrict when 0 then 'No' else 'Yes' end) ;  
		;
		if(@preMaxCallTime<>@MaxCallTime and @MaxCallTime is not null )
			SET @WhatEdit =  @WhatEdit  + '; Max Call Time Changed: ' + cast(@preMaxCallTime as varchar(4)) + '-->' + Cast(@MaxCallTime as varchar(4)); 
		if(@preDNILimit<>@DNILimit)
			SET @WhatEdit =  @WhatEdit  + '; Max DNI Changed: ' + CAST(@preDNILimit as varchar(2)) + '-->' + cast(@DNILimit as varchar(2)) ;  
					
		if(@preMaxCallPerHour<>@MaxCallPerHour and @MaxCallPerHour is not null)
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerHour Changed:' + cast(@preMaxCallPerHour as  varchar(2)) + '-->' + cast(@MaxCallPerHour as  varchar(2)) ;
		if(@preMaxCallPerDay<>@MaxCallPerDay and @MaxCallPerDay is not null )
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerDay Changed: ' + CAST( @preMaxCallPerDay as  varchar(2)) + '-->' + cast(@MaxCallPerDay as  varchar(2));
		if(@preMaxCallPerWeek<>@MaxCallPerWeek and @MaxCallPerWeek is not null )
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerWeek Changed: ' + CAST( @preMaxCallPerWeek  as  varchar(2))+ '-->' + cast(@MaxCallPerWeek as  varchar(2)) ;
		if(@preMaxCallPerMonth<>@MaxCallPerMonth and @MaxCallPerMonth is not null )
			SET @WhatEdit =  @WhatEdit  + '; MaxCallPerMonth Changed: ' + cast(@preMaxCallPerMonth as  varchar(2)) + '-->' + cast(@MaxCallPerMonth as  varchar(2)) ;
		
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
		
		if(@PreFreeCallRemain<>@FreeCallRemain and @FreeCallRemain is not null)
			SET @WhatEdit =  @WhatEdit  + '; Free Call Remain Changed: ' +CAST( @PreFreeCallRemain as  varchar(3)) + '-->' + CAST(@FreeCallRemain  as  varchar(3));	
		
		if(@preAdminNote<>@AdminNote and @AdminNote is not null)
			SET @WhatEdit =  @WhatEdit  + '; AdminNote Changed: ' + @preAdminNote + '-->' +@AdminNote ;
		
	-----------
		if(@WhatEdit <>'')
		 begin
			SET @WhatEdit ='Edit Inmate: ' + @InmateID  + @WhatEdit ;
			EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,	@UserIP,	@InmateID,@WhatEdit
		 end
		RETURN @@error;
END

