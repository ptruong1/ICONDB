
CREATE PROCEDURE [dbo].[p_process_inmate_data_Maine]
@FromFacilityID int,
@InmateID	varchar(12),
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@DOB			varchar(12),
@PhoneBalance	numeric(7,2),
@AllowedMinutes	int,
@status		tinyint,
@facilityName	varchar(100),
@Unit		varchar(30),
@Pod		varchar(30),
@Cell		varchar(30),
@Beb		varchar(20),
@IsAdult	bit,
@ReturnValue smallint,
@Log_ID		int,
@fromNo	char(10),
@userName	varchar(23),
@RecordID	bigint,
@Error_code varchar(3),
@is_Indigent varchar(1)

AS
SET NOCOUNT ON;
Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint ,@TTY tinyint;
Declare @DNIRestrict    tinyint, @AlertEmail        varchar(25),@AlertPage  	Varchar(25)  ,@AlertPhone     Varchar(25),@InmateFirstName	 Varchar(25),@InmateLastName	varchar(25) ,  @SusDate date,
	@InmateStatus		tinyint ,@Register tinyint ,@AcessAllow  smallint,  @AccuPIN tinyint, @BioMetric tinyint,@SuspendStart smalldatetime,@SuspendEnd smalldatetime , @DebitOpt tinyint, @FreeCallNo tinyint,
	@AssignToDivision int, @AssignToLocation int,@AssignToStation int,@StationID int,@DivisionID int,@LocationID int,@NameRecorded tinyint,@TTYphone varchar(10),@DebitAcct varchar(12);
Declare @dayBirth varchar(2), @MonthBirth varchar(2), @yearBirth varchar(4),  @first4BookID varchar(4), @last3BookID varchar(3), @QA varchar(20),@InmateFromNo char(10), @VoiceMessage tinyint, @NewMessage tinyint, @MaxTimeCall smallint;
Declare @visitphone tinyint , @FacilityID int, @AtLocation varchar(30), @AtCurrLoc varchar(30), @AccountNo varchar(12), @LastBalance numeric(7,2), @PrimaryLanguage tinyint;	
SET @CallPerHour  =0;
SET @NameRecorded =0;
SET @CallPerDay =0 ;
SET @CallPerWeek =0;
SET @CallPerMonth =0;
SET @timeZone =0;
SET @Register = 0;
SET @AcessAllow  = 1;
SET  @InmateStatus = 0;
set @AlertPhone ='';
set @AlertPage='';
set  @TTY =0;
set @AccuPIN = 0;
set  @BioMetric = 0;
SET @TTYphone ='0';
SET @DebitAcct='0';
SET @VoiceMessage =0;
SET @NewMessage =0;
SET @DebitOpt  =0;
SET @visitphone =0;
SET @MaxTimeCall =15;
select @timeZone =isnull( timezone,0), @DebitOpt = isnull(DebitOpt,0), @MaxTimeCall = MaxCallTime from tblfacility with(nolock) where facilityID =@FromFacilityID ;
Set  @localtime = dateadd(hh, @timeZone,getdate() );
SET @day = datepart(dw, @localtime);
SET @h = datepart(hh, @localtime);
SET @FreeCallNo =0;
SET @locationID =0;
SET @facilityId =0;
SET  @QA ='';
SET @InmateFirstName ='';
SET @InmateLastName ='';
SET @DNIRestrict=0;
SET @AlertEmail='';
SET @AccountNo ='0';
SET @LastBalance =0;
SET  @PrimaryLanguage =1;
select @facilityId = FacilityID from tblfacility with(nolock)  where location like @facilityName +'%';

Insert tblMaineLogs (PIN,InmateID,LastName ,FirstName,MidName ,DOB ,PhoneBalance ,AllowedMinutes ,CurrentStatus ,Facility,Unit , Pod ,  Cell ,  IsAdult, ReturnValue, Log_ID  , RecordDate, error_ID,ReferenceNo, APItype,FacilityID,is_Indigent,FromNo)
values (@pin, @InmateID,@lastName,@firstName,@MidName,@DOB, @PhoneBalance, @AllowedMinutes, @status,@facilityName,@Unit,@Pod,@Cell,@IsAdult,@ReturnValue,@Log_ID,getdate(),@Error_code, @RecordID,1,@FromFacilityID,@is_Indigent, @fromNo);
/*
if(@FromFacilityID <> @FacilityID)
begin
	EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@FromFacilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
	--SET @AcessAllow =-1;
	--GOTO SelectOut;
end
*/
SET @InmateID = replace(@InmateID,'"','');
SET @InmateID = RTRIM(ltrim(@InmateID));
SET @PIN = replace(@PIN,'"','');
set @PIN = ltrim(rtrim(@PIN));	
set @firstName	 = ltrim(@firstName);
SET @lastName = ltrim(@lastName);
SET @firstName = replace(@firstName,'"','');
SET @lastName = replace(@lastName,'"','');
SET @MidName = replace(@MidName,'"','');
SET @lastName = replace(@lastName,',','');
SET @firstName = replace(@firstName,',','');
SET @MidName = replace(@MidName,',','');

-- Put restrict inmate use the 2 phone at the same time
/*
select @InmateFromNo= Fromno from tblinmateoncall with(nolock) where PIN=@PIN and facilityID = @facilityID  and  Accesstime > dateadd(MINUTE,-@MaxTimeCall,GETDATE());
if((@InmateFromNo is not null and @InmateFromNo <>'' and @InmateFromNo <> @fromNo))
 begin
	EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 21 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
	SET @AcessAllow =-1;
	GOTO SelectOut;
 end

Else 
 begin
		insert tblinmateOncall (PIN, FacilityID, AccessTime, fromNo, InmateID) values(@PIN,@facilityID ,GETDATE(), @fromNo , @InmateID); 
 end
*/

If(@InmateID <>'' and @Status >0)
 begin	
	
	If (((select count(*) from  tblInmate  where  FacilityID =   @facilityID and InmateID= @InmateID) =  0)  )
 		Begin
			if( select count(*) from tblFacilityOption where FacilityID =@FromFacilityID and DNIrestrictOpt=1 ) =0
			 begin
				INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate, modifyDate , DOB ,SEX )
				Values( @InmateID,@lastName, @FirstName,@MidName,@status, 0,0,0, @facilityID,  @PIN,getdate(),getdate(), @DOB , 'U');
			 end
			else
			 begin
				INSERT tblInmate(InmateID   ,    LastName       ,     FirstName ,MidName  ,  Status, DNIRestrict, DateTimeRestrict,    DNILimit ,FacilityId,   PIN,inputdate, modifyDate , DOB ,SEX )
				Values( @InmateID,@lastName, @FirstName,@MidName,@status, 1,0,0, @facilityID,  @PIN,getdate(),getdate(), @DOB , 'U');
			 end

		End
	else
		Begin	
		   
			UPDATE tblInmate SET  [status] = @status ,LastName=@lastName ,FirstName =@firstName,MidName=@MidName, modifyDate = getdate(), PIN= @PIN  where  inmateID = @InmateID and FacilityID = @facilityID ;
		End
 	
	Select @AccountNo= AccountNo, @LastBalance = Balance  from tblDebit where InmateID = @InmateID and facilityID = @FacilityID;
	if(@AccountNo='0')
	 Begin
		exec p_get_new_AccountNo  @AccountNo  OUTPUT;
		set @i  = 1;
		while @i = 1
			Begin
				select  @i = count(*) from tblDebit where Accountno = @AccountNo;
				If  (@i > 0 ) 
					Begin
						exec p_get_new_AccountNo  @AccountNo  OUTPUT;
						SET @i = 1;
					end
			end 
        Declare @nextID bigint; 
        EXEC    p_create_nextID 'tblDebit', @nextID   OUTPUT  
		INSERT INTO [tblDebit] ([RecordID], [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	    VALUES (@nextID , @AccountNo ,@facilityID,@inmateID, getdate(), @PhoneBalance,@PhoneBalance,1, 'Maine', 'Maine');
	 End
	Else
	 begin
		Update [tblDebit] SET Balance =@PhoneBalance,[ReservedBalance]= @LastBalance , modifyDate= GETDATE() where AccountNo = @AccountNo;
	 end
	
	SET @DebitAcct = @AccountNo;
	/*  Not Now
	if( @Pod<>'')
	Begin 
   
	   select  @AtLocation = isnull(AtLocation,''),@i= COUNT(*) from  tblVisitInmateConfig	with(nolock)
			where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
		
	   select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId and (LocationName = @Pod or LocationName = @Unit );
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName like @Pod + '%' );
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  ( LocationName like @unit+ '%');
   
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName = left(@unit,3));
	   if(@locationID =0)
			select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
			and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName = left(@unit,4));
  
	   if(@locationID =0)
			select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationType =2 and StationID   like '%'+ @AtCurrLoc + '%' ;

		
	
	   if (@i >0 ) 
		begin
			--if (@AtCurrLoc <> @AtLocation)
				update tblVisitInmateConfig set AtLocation = @Pod, LocationID =@locationID, ModifyDate = getdate() where FacilityID =@facilityId and InmateID =@InmateID;
		end
	   else
		begin   	
			Insert leg_Icon.dbo.tblVisitInmateConfig (InmateID,FacilityID,AtLocation, LocationID, VisitPerDay  )
						values(@InmateID ,@facilityId,@Pod,@locationID,2);
		end
	
	  End
	  */
 End

If(@Error_code ='0' or @Error_code ='' or @Error_code ='999')
begin
	select  @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict , @DNIRestrict=DNIRestrict   , @InmateStatus	 = status,@InmateFirstName= FirstName,
					@InmateLastName = LastName,	@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0) ,  @TTY = isnull(TTY,0),
						@SuspendStart = StartDate, @SuspendEnd = EndDate, @AssignToDivision = AssignToDivision,  @AssignToLocation= AssignToLocation,  @AssignToStation= AssignToStation,@NameRecorded = isnull(NameRecorded,0), @FreeCallNo = isnull(FreeCallRemain,0),  @PrimaryLanguage =isnull( PrimaryLanguage,1)
					From tblInmate  with(nolock)  where PIN   = @PIN   and  facilityID =@facilityID ;

	If(@InmateStatus=1 and (@Error_code ='999' or @Error_code =''))
		begin
			select @AllowedMinutes= AllowedMinutes, @PhoneBalance= Phonebalance from tblMaineLogs with(nolock) where pin =@PIN and Error_ID='0' and APItype=1;
		end	

	 ---- New edit on 121/29/2018 for maine, It used to Our DB for suspend now now
   SET  @SusDate = convert(date,@localtime, 112);
   If (@SuspendStart is not NULL AND @SuspendStart <= @SusDate and @SuspendEnd is NOT NULL and  @SuspendEnd >= @SusDate )
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
		SET @AcessAllow =-1;
		GOTO SelectOut;
	 end

end

 If (@AllowedMinutes >0 and (@PhoneBalance >0.08  or (@PhoneBalance >0.08 and @is_Indigent='Y')) )
  begin
		If( @InmateStatus=1)
		  Begin	
			IF ( @DateTimeRestrict = 1) 
			 Begin
				  IF( select count(*) from tblPINTimeCall with(nolock) where PIN =@PIN and days = @day  and facilityID = @facilityID  and  hours & power(2, @h) >0) > 0
				Begin
					EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
					SET @AcessAllow =0;
			
					GOTO SelectOut;
				End
			 End
			If ( @CallPerHour >0 )
			 Begin
				--If( dbo.fn_getCallsPerHourByPIN (@PIN, @localtime) > @CallPerHour   )
				 If (dbo.fn_getCallsPerHourByPIN_Facility (@PIN, @localtime, @facilityID)  > @CallPerHour   )
				 Begin
					EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
					SET @AcessAllow =0;
					GOTO SelectOut;
				End
			 end
			If ( @CallPerDay >1 )
			 Begin
				--If(  dbo.fn_getCallsPerDayByPIN (@PIN, @localtime) >  @CallPerDay   )
				If(  dbo.fn_getCallsPerDayByPIN_Facility (@PIN, @localtime,  @facilityID) >  @CallPerDay   )
				Begin
					EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
					SET @AcessAllow =0;
					GOTO SelectOut;
				End
			 end
			If ( @CallPerWeek >1 )
			 Begin
				--If(  dbo.fn_getCallsPerWeekByPIN (@PIN, @localtime) >  @CallPerWeek   ) 
				If(  dbo.fn_getCallsPerWeekByPIN_facility (@PIN, @localtime,@facilityID ) >  @CallPerWeek   ) 
				Begin
					EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
					SET @AcessAllow =0;
					GOTO SelectOut;
				End
			 end
			If ( @CallPerMonth >1 )
			 Begin
				--If(  dbo.fn_getCallsPerMonthByPIN (@PIN, @localtime) >  @CallPerMonth   )  
				If(  dbo.fn_getCallsPerMonthByPIN_facility (@PIN, @localtime,@facilityID ) >  @CallPerMonth   )  
				Begin
					EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
					SET @AcessAllow =0;
			
				End
			 end
			
			Select @AccuPin =isnull(AccuPin ,0),@BioMetric= isnull( BioMetric,0), @VoiceMessage= isnull(VoiceMessageOpt,0)  From leg_Icon.dbo.tblFacilityOption with(nolock) where FacilityID = @facilityID;
    
			if (select count(*) from tblVoiceBioException with(nolock) where facilityID = @facilityID and inmateID = @inmateID and [VoiceStatus]=1) >0
				set @BioMetric =0;
		 End
		Else 
		 Begin
			EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 6 ,@PIN	,'0' ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
  			SET @AcessAllow = 0;
		 End
		
		--if (@TTY =1)
		--	Select @TTYphone =  TTYphone  FROM [leg_Icon].[dbo].[tblTTYphones] with(nolock) where FacilityId = @facilityID;
		--if(@DebitOpt =1) --- New Update if debit opt than select account
		--	select @DebitAcct = AccountNO from [leg_Icon].[dbo].tblDebit with(nolock) where inmateID=@inmateID and facilityID = @facilityID;

		--if(@AccuPIN =1)
		-- begin
		--		EXEC  p_determine_AccuPIN_question @FacilityID,@InmateID,  @QA OUTPUT ;   --Modify on 3/28/2016 passing InmateID instead of PIn
		--		if(@QA ='')
		--			SET @AccuPIN =0;
		
		-- end 	
		--if(@VoiceMessage =1)
		-- begin
		--	select @NewMessage = COUNT(b.MessageID) from tblMailbox a with(nolock) , tblMailboxDetail b with(nolock) 
		--		where a.MailboxID =b.MailBoxID and a.InmateID =@inmateID and a.FacilityID =@facilityID and b.IsNew =1  and b.MessageStatus =2
		--		and datediff(day, MessageDate,getdate()) <10 and readcount <4;
			
		-- end



 end
else
 begin
	SET @AcessAllow =@status;
	SET @InmateStatus= @status;
	SET @InmateLastName = @lastName;
	SET  @InmateFirstName = @firstName;
			
	If(@status >1)
		SET @AcessAllow =0;
	if (@AllowedMinutes =0)
		set @AcessAllow=-1;
	 If (@Error_code ='114')
		set @AcessAllow=-2;
	 Else If (@Error_code ='101')
		set @AcessAllow=0;
	 Else If (@Error_code ='102')
		set @AcessAllow=-3;
	 Else If (@Error_code in ('999','103','104','105','106','108','109','110'))
		set @AcessAllow=-4;
	 If(@status =0 and @Error_code='0')
		SET @AcessAllow = -5;
 end
 ---- For testing
 --If ( @PIN= '04041969')
 -- begin
	--SET @AcessAllow =1;
	--SET @AllowedMinutes=15;
	--SET  @BioMetric=0;
	--SET @InmateID ='123123';
	--SET @InmateStatus =1;
	--Select @DebitAcct= AccountNo, @LastBalance = Balance  from tblDebit where InmateID = @InmateID and facilityID = @FromFacilityID and status =1;
 -- end
 SelectOut:
	 If(@is_Indigent='Y' and @IsAdult=0  and @Error_code='0' and @status=1) --or ( @PIN= '04041969' and @InmateID ='123123' and @FromFacilityID=792 ))
	 begin
		SET @AcessAllow =1;
		SET @FreeCallNo =1;
	 end
	 if(@AllowedMinutes > @MaxTimeCall)
		SET @AllowedMinutes = @MaxTimeCall;
    
	 if (@PrimaryLanguage  >0)
	 begin
		declare @lang varchar(6);
		select @lang  = Abbrev + '#' + cast( @PrimaryLanguage as varchar(2))  from tblLanguages with(nolock) where ACPSelectOpt = @PrimaryLanguage;
	 end
	Select  @inmateID as InmateID, @AcessAllow as AccessAllow , @InmateFirstName as FirstName,@InmateLastName as LastName , @InmateStatus  as Status ,@Register as Register  , @DNIRestrict   as DNIRestrict ,
	@AlertEmail  as  AlertEmail   ,   @AlertPhone  as AlertPhone,    @TTYphone  as  TTY, @AccuPIN As AccuPIN,   @BioMetric  as BioMetric,@NameRecorded as NameRecorded, @DebitAcct as DebitAcct, @QA  as AccuQA, 
	@VoiceMessage as VoiceMessage, @NewMessage as NewMessage, @FreeCallNo as FreeCallNo, @AllowedMinutes as MaxCalltime, @lang as  PrimaryLanguage ;


