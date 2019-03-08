CREATE PROCEDURE [dbo].[p_get_InmateInfo_Web_service2_test]
@PIN  varchar(12),
@fromNo	char(10),
@facilityID	int, 
@userName	varchar(23),
@RecordID	bigint
 AS

Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint ,@TTY tinyint;
Declare @DNIRestrict    tinyint, @AlertEmail        varchar(25),@AlertPage  	Varchar(25)  ,@AlertPhone     Varchar(25),@InmateFirstName	 Varchar(25),@InmateLastName	varchar(25) ,  @SusDate date, @PrimaryLanguage tinyint,
	@InmateStatus		tinyint ,@Register tinyint ,@AcessAllow  smallint,  @inmateID varchar(12), @AccuPIN tinyint, @BioMetric tinyint,@SuspendStart smalldatetime,@SuspendEnd smalldatetime , @DebitOpt tinyint, @FreeCallNo tinyint,
	@AssignToDivision int, @AssignToLocation int,@AssignToStation int,@StationID int,@DivisionID int,@LocationID int,@NameRecorded tinyint,@TTYphone varchar(10),@DebitAcct varchar(12);
Declare @dayBirth varchar(2), @MonthBirth varchar(2), @yearBirth varchar(4),  @first4BookID varchar(4), @last3BookID varchar(3), @QA varchar(20),@InmateFromNo varchar(10), @VoiceMessage tinyint, @NewMessage tinyint, @MaxTimeCall smallint;
Declare @visitphone tinyint,  @lang as varchar(6);
SET  @lang ='0';	
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
SET  @PrimaryLanguage =0;
select @timeZone =isnull( timezone,0), @DebitOpt = isnull(DebitOpt,0), @MaxTimeCall = MaxCallTime from tblfacility with(nolock) where facilityID =@facilityID ;
Set  @localtime = dateadd(hh, @timeZone,getdate() );
SET @day = datepart(dw, @localtime);
SET @h = datepart(hh, @localtime);
SET @FreeCallNo =0;

select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict , @DNIRestrict=DNIRestrict   , @InmateStatus	 = status,@InmateFirstName= FirstName,
			@InmateLastName = LastName,	@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0) ,  @TTY = isnull(TTY,0),
			 @SuspendStart = StartDate, @SuspendEnd = EndDate, @AssignToDivision = AssignToDivision,  @AssignToLocation= AssignToLocation,  @AssignToStation= AssignToStation,@NameRecorded = isnull(NameRecorded,0), @FreeCallNo = isnull(FreeCallRemain,0),  @PrimaryLanguage =isnull(PrimaryLanguage,0)
			From tblInmate  with(nolock)  where            PIN   = @PIN   and  facilityID =@facilityID and [Status]=1;

select @InmateFromNo= Fromno from tblinmateoncall with(nolock) where PIN=@PIN and facilityID = @facilityID  and  Accesstime > dateadd(MINUTE,-@MaxTimeCall,GETDATE());

--select @InmateFromNo;

select @visitphone = count(*) from tblvisitphone with(nolock) where EXTID = @fromNo and facilityID = @facilityID;


if((@InmateFromNo is not null and @InmateFromNo <>'' and @InmateFromNo <> @fromNo) and @visitphone=0)
 begin
	EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 21 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
	SET @AcessAllow =-1;
	GOTO SelectOut;
 end
SET  @SusDate = convert(date,@localtime, 112);
If (@SuspendStart is not NULL AND @SuspendStart <= @SusDate and @SuspendEnd is NOT NULL and  @SuspendEnd >= @SusDate )
 begin
	EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
	SET @AcessAllow =-1;
	GOTO SelectOut;
 end
If(((@AssignToDivision is not NULL and @AssignToDivision>0)   or  ( @AssignToLocation  is not NULL and @AssignToLocation>0) or  (@AssignToStation is not NULL and @AssignToStation >0)) and @visitphone=0)
 begin
 	Select @StationID       =phoneID,       @DivisionID  = DivisionID, @LocationID= LocationID  from tblANIs with(nolock) where ANIno = @fromNo;
	if( @AssignToDivision is not NULL and @AssignToDivision <> @DivisionID) 
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
		SET @AcessAllow =0;
		GOTO SelectOut;
	 end
	If(   @AssignToLocation   is not NULL and   @AssignToLocation   <> @LocationID)
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
		SET @AcessAllow =0;
		GOTO SelectOut;
	 end
	If (  @AssignToStation    is not NULL  and  @AssignToStation    <>  @StationID)
	 begin
		EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 9 ,@PIN	,@inmateID ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
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
	if(@PIN <> '0' and  @PIN not in ( '9999420','765602442','1475635527','123123') AND @TTY =0)  
	 begin
		--delete tblinmateOncall where facilityID = @FacilityID and fromNo = @fromNo and Pin = @PIN;
		insert tblinmateOncall values(@PIN,@facilityID ,GETDATE(), @fromNo ); 
	 end

	Select @AccuPin =isnull(AccuPin ,0),@BioMetric= isnull( BioMetric,0), @VoiceMessage= isnull(VoiceMessageOpt,0)  From leg_Icon.dbo.tblFacilityOption with(nolock) where FacilityID = @facilityID;
    
	--USING FOR LEGACY TEST 
	If (@PIN in ('9999420','765602442','1475635527','123123','1219828535','1117395961','1475635805','1475630282','131313'))
		set @BioMetric =0;
    if (select count(*) from tblVoiceBioException with(nolock) where facilityID = @facilityID and inmateID = @inmateID and [VoiceStatus]=1) >0
		set @BioMetric =0;
  End
Else 
 Begin
	EXEC  p_insert_unbilled_calls4   '','',  @fromno ,'' ,'', 6 ,@PIN	,'0' ,@facilityID	,@userName, '', '','',@localtime,'NA',@RecordID;
  	SET @AcessAllow = 0;
 End
SelectOut:
if (@TTY =1)
	Select @TTYphone =  TTYphone  FROM [leg_Icon].[dbo].[tblTTYphones] with(nolock) where FacilityId = @facilityID;
if(@DebitOpt =1) --- New Update if debit opt than select account
 begin
	Declare @DebitBalance numeric(5,2);
	SET @DebitBalance =0;
	select @DebitAcct = AccountNO, @DebitBalance = Balance from [leg_Icon].[dbo].tblDebit with(nolock) where inmateID=@inmateID and facilityID = @facilityID;
	If(@DebitBalance <= 0.20 and @facilityID in (43,786,325))
		SET @DebitAcct ='0';

 end

if(@AccuPIN =1)
 begin
	    EXEC  p_determine_AccuPIN_question @FacilityID,@InmateID,  @QA OUTPUT ;   --Modify on 3/28/2016 passing InmateID instead of PIn
		if(@QA ='')
			SET @AccuPIN =0;
		
 end 	
if(@VoiceMessage =1)
 begin
	select @NewMessage = COUNT(b.MessageID) from tblMailbox a with(nolock) , tblMailboxDetail b with(nolock) 
		where a.MailboxID =b.MailBoxID and a.InmateID =@inmateID and a.FacilityID =@facilityID and b.IsNew =1  and b.MessageStatus =2
		and datediff(day, MessageDate,getdate()) <10 and readcount <4;
			
 end

if (@PrimaryLanguage  >0)
 begin
	select @lang  = Abbrev + '#' + cast( @PrimaryLanguage as varchar(2))  from tblLanguages with(nolock) where ACPSelectOpt = @PrimaryLanguage;
 end


Select  @inmateID as InmateID, @AcessAllow as AccessAllow , @InmateFirstName as FirstName,@InmateLastName as LastName , @InmateStatus  as Status ,@Register as Register  , @DNIRestrict   as DNIRestrict ,
  	@AlertEmail      as  AlertEmail   ,   @AlertPhone  as AlertPhone,    @TTYphone  as  TTY, @AccuPIN As AccuPIN,   @BioMetric  as BioMetric,@NameRecorded as NameRecorded, @DebitAcct as DebitAcct, @QA  as AccuQA, 
  	@VoiceMessage as VoiceMessage, @NewMessage as NewMessage, @FreeCallNo as FreeCallNo, @MaxTimeCall   as  MaxDuration, @lang as  PrimaryLanguage ;
