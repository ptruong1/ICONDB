CREATE PROCEDURE [dbo].[p_verify_PIN5]
@PIN  varchar(12),
@fromNo	char(10),
@facilityID	int, 
@userName	varchar(23),
@projectcode	char(6) ,
@DNIRestrict    tinyint OUTPUT,
@inmateID	varchar(12)  OUTPUT,
@AlertEmail        varchar(25) OUTPUT,
@AlertPage  	Varchar(25)  OUTPUT ,
@AlertPhone     Varchar(25)  OUTPUT,
@InmateFirstName	varchar(25) OUTPUT,
@InmateLastName	varchar(25) OUTPUT,
@InmateStatus		tinyint OUTPUT,
@Register		tinyint OUTPUT
 AS

Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint ,@TTY bit
SET @CallPerHour  =0 
SET @CallPerDay =0 
SET @CallPerWeek =0
SET @CallPerMonth =0
SET @timeZone =0
SET @Register = 0

select @timeZone =isnull( timezone,0) from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)


select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict , @DNIRestrict=DNIRestrict   , @InmateStatus	 = status,@InmateFirstName= FirstName,
			@InmateLastName = LastName,	@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0) ,  @TTY = isnull(TTY,0),
			@Register = isnull(NameRecorded,0) From tblInmate  with(nolock)  where            PIN   = @PIN   and  facilityID =@facilityID
If( @InmateStatus=1)
  Begin

	IF ( @DateTimeRestrict = 1) 
	 Begin
	      IF( select count(*) from tblPINTimeCall with(nolock) where PIN =@PIN and days = @day  and  hours & power(2, @h) >0) > 0
		Begin
			EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
			Return -1
		End
	 End
	If ( @CallPerHour >0 )
	 Begin
		If( dbo.fn_getCallsPerHourByPIN (@PIN, @localtime) > @CallPerHour   )  
		Begin
			EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
			Return -1
		End
	 end
	If ( @CallPerDay >0 )
	 Begin
		If(  dbo.fn_getCallsPerDayByPIN (@PIN, @localtime) >  @CallPerDay   ) 
		Begin
			EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
			Return -1
		End
	 end
	If ( @CallPerWeek >0 )
	 Begin
		If(  dbo.fn_getCallsPerWeekByPIN (@PIN, @localtime) >  @CallPerWeek   ) 
		Begin
			EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
			Return -1
		End
	 end
	If ( @CallPerMonth >0 )
	 Begin
		If(  dbo.fn_getCallsPerMonthByPIN (@PIN, @localtime) >  @CallPerMonth   )  
		Begin
			EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
			Return -1
		End
	 end
	If (@TTY = 1 ) Return 1
  End
Else 
 Begin
	EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 6 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
  	Return -2
 End
