CREATE PROCEDURE [dbo].[p_get_InmateInfo_Web_service1_test]
@PIN  varchar(12),
@fromNo	char(10),
@facilityID	int, 
@userName	varchar(23),
@RecordID	bigint
 AS

Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint ,@TTY tinyint;
Declare @DNIRestrict    tinyint, @AlertEmail        varchar(25),@AlertPage  	Varchar(25)  ,@AlertPhone     Varchar(25),@InmateFirstName	 Varchar(25),@InmateLastName	varchar(25) ,
	@InmateStatus		tinyint ,@Register tinyint ,@AcessAllow  smallint,  @inmateID varchar(12), @AccuPIN tinyint, @BioMetric tinyint,@SuspendStart smalldatetime,@SuspendEnd smalldatetime,
	@AssignToDivision int, @AssignToLocation int,@AssignToStation int,@StationID int,@DivisionID int,@LocationID int,@NameRecorded tinyint,@TTYphone varchar(10),@DebitAcct varchar(12);
Declare @dayBirth varchar(2), @MonthBirth varchar(2), @yearBirth varchar(4),  @first4BookID varchar(4), @last3BookID varchar(3), @QA varchar(20),@InmateFromNo char(10), @VoiceMessage tinyint, @NewMessage tinyint;
	
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

select @timeZone =isnull( timezone,0) from tblfacility with(nolock) where facilityID =@facilityID;
Set  @localtime = dateadd(hh, @timeZone,getdate() );
SET @day = datepart(dw, @localtime);
SET @h = datepart(hh, @localtime);


select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict , @DNIRestrict=DNIRestrict   , @InmateStatus	 = status,@InmateFirstName= FirstName,
			@InmateLastName = LastName,	@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0) ,  @TTY = isnull(TTY,0),
			 @SuspendStart = StartDate, @SuspendEnd = EndDate, @AssignToDivision = AssignToDivision,  @AssignToLocation= AssignToLocation,  @AssignToStation= AssignToStation,@NameRecorded = isnull(NameRecorded,0)
			From tblInmate  with(nolock)  where            PIN   = @PIN   and  facilityID =@facilityID and [Status]=1;

select @InmateFromNo= Fromno from tblinmateoncall where PIN=@PIN and facilityID = @facilityID  and  Accesstime > dateadd(MINUTE,-15,GETDATE());
--select @InmateFromNo;
if(@InmateFromNo is not null and @InmateFromNo <> @fromNo)
 begin
	--EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
	SET @AcessAllow =0;
	GOTO SelectOut;
 end

If (@SuspendStart is not NULL AND @SuspendStart < @localtime and @SuspendEnd is NOT NULL and  @SuspendEnd > @localtime )
 begin
	EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
	SET @AcessAllow =0;
	GOTO SelectOut;
 end
If(@AssignToDivision is not NULL  or   @AssignToLocation   is not NULL or  @AssignToStation    is not NULL )
 begin
 	Select @StationID       =phoneID,       @DivisionID  = DivisionID, @LocationID= LocationID  from tblANIs with(nolock) where ANIno = @fromNo;
	if( @AssignToDivision is not NULL and @AssignToDivision <> @DivisionID) 
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
		SET @AcessAllow =0;
		GOTO SelectOut;
	 end
	If(   @AssignToLocation   is not NULL and   @AssignToLocation   <> @LocationID)
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
		SET @AcessAllow =0;
		GOTO SelectOut;
	 end
	If (  @AssignToStation    is not NULL  and  @AssignToStation    <>  @StationID)
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
		SET @AcessAllow =0;
		GOTO SelectOut;
	 end
 end
If( @InmateStatus=1)
  Begin
	
	IF ( @DateTimeRestrict = 1) 
	 Begin
	      IF( select count(*) from tblPINTimeCall with(nolock) where PIN =@PIN and days = @day  and facilityID = @facilityID  and  hours & power(2, @h) >0) > 0
		Begin
			EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
			SET @AcessAllow =0;
			
			GOTO SelectOut;
		End
	 End
	If ( @CallPerHour >0 )
	 Begin
		--If( dbo.fn_getCallsPerHourByPIN (@PIN, @localtime) > @CallPerHour   )
		 If (dbo.fn_getCallsPerHourByPIN_Facility (@PIN, @localtime, @facilityID)  > @CallPerHour   )
		 Begin
			EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
			SET @AcessAllow =0;
			GOTO SelectOut;
		End
	 end
	If ( @CallPerDay >0 )
	 Begin
		--If(  dbo.fn_getCallsPerDayByPIN (@PIN, @localtime) >  @CallPerDay   )
		If(  dbo.fn_getCallsPerDayByPIN_Facility (@PIN, @localtime,  @facilityID) >  @CallPerDay   )
		Begin
			EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
			SET @AcessAllow =0;
			GOTO SelectOut;
		End
	 end
	If ( @CallPerWeek >0 )
	 Begin
		--If(  dbo.fn_getCallsPerWeekByPIN (@PIN, @localtime) >  @CallPerWeek   ) 
		If(  dbo.fn_getCallsPerWeekByPIN_facility (@PIN, @localtime,@facilityID ) >  @CallPerWeek   ) 
		Begin
			EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
			SET @AcessAllow =0;
			GOTO SelectOut;
		End
	 end
	If ( @CallPerMonth >0 )
	 Begin
		--If(  dbo.fn_getCallsPerMonthByPIN (@PIN, @localtime) >  @CallPerMonth   )  
		If(  dbo.fn_getCallsPerMonthByPIN_facility (@PIN, @localtime,@facilityID ) >  @CallPerMonth   )  
		Begin
			EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
			SET @AcessAllow =0;
			
		End
	 end
	if(@PIN <> '0' and @TTY =0)  
		insert tblinmateOncall values(@PIN,@facilityID ,GETDATE(), @fromNo ); 
	Select @AccuPin =isnull(AccuPin ,0),@BioMetric= isnull( BioMetric,0), @VoiceMessage= isnull(VoiceMessageOpt,0)  From leg_Icon.dbo.tblFacilityOption with(nolock) where FacilityID = @facilityID;
  End
Else 
 Begin
	EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 6 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
  	SET @AcessAllow = 0;
 End
SelectOut:
if (@TTY =1)
	Select @TTYphone =  TTYphone  FROM [leg_Icon].[dbo].[tblTTYphones] with(nolock) where FacilityId = @facilityID;

select @DebitAcct = AccountNO from [leg_Icon].[dbo].tblDebit with(nolock) where inmateID=@inmateID and facilityID = @facilityID;

if(@AccuPIN =1)
 begin
	SET @dayBirth='';
	SET @MonthBirth='';
	SET @yearBirth='';
	SET @first4BookID='';
	SET @last3BookID='';
	SET @QA ='';
	select @dayBirth= substring(BirthDate,4,2) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID order by BookingNo;
	if(@dayBirth='')
		select @dayBirth= substring(DOB,4,2) from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID ;
	select @MonthBirth=		left(BirthDate,2) from	tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  order by BookingNo;
	if(@MonthBirth=	'')
		select @MonthBirth=	left(DOB,2)from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  ;
	select @yearBirth = right(BirthDate,4) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  order by BookingNo;
	if( @yearBirth ='')
		select @MonthBirth= right(DOB,4) from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  ;
	select @first4BookID=Left(BookingNo ,4) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  order by BookingNo;
	select @last3BookID = right(BookingNo ,3) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID  order by BookingNo ;
	if(@dayBirth<>'')
		SET @QA = @dayBirth + '_' + @MonthBirth + '_' + @yearBirth + '_' + @first4BookID + '_' + @last3BookID;
		
 end 	
if(@VoiceMessage =1)
 begin
	select @NewMessage = COUNT(b.MessageID) from tblMailbox a with(nolock) , tblMailboxDetail b with(nolock) 
	where a.MailboxID =b.MailBoxID and a.InmateID =@inmateID and b.IsNew =1
 end
Select  @inmateID as InmateID, @AcessAllow as AccessAllow , @InmateFirstName as FirstName,@InmateLastName as LastName , @InmateStatus  as Status ,@Register as Register  , @DNIRestrict   as DNIRestrict ,
  	@AlertEmail      as  AlertEmail   ,   @AlertPhone  as AlertPhone,    @TTYphone  as  TTY, @AccuPIN As AccuPIN,   @BioMetric  as BioMetric,@NameRecorded as NameRecorded, @DebitAcct as DebitAcct, @QA  as AccuQA, 
  	@VoiceMessage as VoiceMessage, @NewMessage as NewMessage ;
