
CREATE PROCEDURE [dbo].[p_verify_PIN2]
@PIN  varchar(12),
@fromNo	char(10),
@facilityID	int, 
@userName	varchar(23),
@projectcode	char(6) ,
@DNIRestrict    tinyint OUTPUT,
@inmateID	bigint  OUTPUT,
@AlertEmail        varchar(25) OUTPUT,
@AlertPage  	Varchar(25)  OUTPUT ,
@AlertPhone     Varchar(25)  OUTPUT
 AS

Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint
SET @CallPerHour  =0 
SET @CallPerDay =0 
SET @CallPerWeek =0
SET @CallPerMonth =0
SET @timeZone =0

select @timeZone =isnull( timezone,0) from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)


IF( select count(*)   From tblInmate  with(nolock)  where            PIN   = @PIN  and Status =1) > 0
 Begin
	select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict    ,
			@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0)
			From tblInmate  with(nolock)  where            PIN   = @PIN  and Status =1

	IF ( @DateTimeRestrict = 1) 
	 Begin
	      IF( select count(*) from tblPINTimeCall with(nolock) where PIN =@PIN and days = @day  and  hours & power(2, @h) >0) > 0
			Return -1
	 End
	If ( @CallPerHour >0 )
	 Begin
		If( dbo.fn_getCallsPerHourByPIN (@PIN, @localtime) > @CallPerHour   )  Return -1
	 end
	If ( @CallPerDay >0 )
	 Begin
		If(  dbo.fn_getCallsPerDayByPIN (@PIN, @localtime) >  @CallPerDay   )  Return -1
	 end
	If ( @CallPerWeek >0 )
	 Begin
		If(  dbo.fn_getCallsPerWeekByPIN (@PIN, @localtime) >  @CallPerWeek   )  Return -1
	 end
	If ( @CallPerMonth >0 )
	 Begin
		If(  dbo.fn_getCallsPerMonthByPIN (@PIN, @localtime) >  @CallPerMonth   )  Return -1
	 end
  End
Else 
 Begin
	EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 6 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
  	Return -2
 End

