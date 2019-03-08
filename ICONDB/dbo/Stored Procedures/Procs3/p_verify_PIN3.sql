
CREATE PROCEDURE [dbo].[p_verify_PIN3]
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

Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint ,@TTY bit
SET @CallPerHour  =0 
SET @CallPerDay =0 
SET @CallPerWeek =0
SET @CallPerMonth =0
SET @timeZone =0

select @timeZone =isnull( timezone,0) from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)


IF( select count(*)   From tblInmate  with(nolock)  where            PIN   = @PIN and facilityID = @facilityID   and Status =1  and (endDate>=@localtime  or endDate is null) and (StartDate <=@localtime or StartDate is null)) > 0
 Begin
	select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict    ,
			@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0) ,  @TTY = isnull(TTY,0)
			From tblInmate  with(nolock)  where          PIN   = @PIN and facilityID = @facilityID   and Status =1 
	

	IF ( @DateTimeRestrict = 1) 
	 Begin
	      IF( select count(*) from tblPINTimeCall with(nolock) where PIN =@PIN and days = @day  and facilityID = @facilityID  and  hours & power(2, @h) >0) > 0
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode,'',@localtime
			Return -1
		End
	 End
	If ( @CallPerHour >0 )
	 Begin
		--If( dbo.fn_getCallsPerHourByPIN (@PIN, @localtime) > @CallPerHour   )
		 If (dbo.fn_getCallsPerHourByPIN_Facility (@PIN, @localtime, @facilityID)  >= @CallPerHour   )
		 Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode,'',@localtime
			Return -1
		End
	 end
	If ( @CallPerDay >0 )
	 Begin
		--If(  dbo.fn_getCallsPerDayByPIN (@PIN, @localtime) >  @CallPerDay   )
		If(  dbo.fn_getCallsPerDayByPIN_Facility (@PIN, @localtime,  @facilityID) >=  @CallPerDay   )
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode,'',@localtime
			Return -1
		End
	 end
	If ( @CallPerWeek >0 )
	 Begin
		--If(  dbo.fn_getCallsPerWeekByPIN (@PIN, @localtime) >  @CallPerWeek   ) 
		If(  dbo.fn_getCallsPerWeekByPIN_facility (@PIN, @localtime,@facilityID ) >=  @CallPerWeek   ) 
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode,'',@localtime
			Return -1
		End
	 end
	If ( @CallPerMonth >0 )
	 Begin
		--If(  dbo.fn_getCallsPerMonthByPIN (@PIN, @localtime) >  @CallPerMonth   )  
		If(  dbo.fn_getCallsPerMonthByPIN_facility (@PIN, @localtime,@facilityID ) >=  @CallPerMonth   )  
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode,'',@localtime
			Return -1
		End
	 end
	If (@TTY = 1 ) Return 1
  End
Else 
 Begin
	EXEC    p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 6,@PIN	,0 ,@facilityID	,@userName, '', @projectcode,'',@localtime
  	Return -2
 End
