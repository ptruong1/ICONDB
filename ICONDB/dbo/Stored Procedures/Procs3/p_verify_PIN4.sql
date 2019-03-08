
CREATE PROCEDURE [dbo].[p_verify_PIN4]
@PIN  varchar(12),
@fromNo	char(10),
@facilityID	int, 
@userName	varchar(23),
@projectcode	char(6) ,
@DNIRestrict    tinyint OUTPUT,
@inmateID	bigint  OUTPUT,
@AlertEmail        varchar(25) OUTPUT,
@AlertPage  	Varchar(25)  OUTPUT ,
@AlertPhone     Varchar(25)  OUTPUT,
@InmateFirstName	varchar(25) OUTPUT,
@InmateLastName	varchar(25) OUTPUT,
@InmateStatus		tinyint OUTPUT
 AS
Set NOCOUNT ON
Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint ,@TTY bit
Declare  @SuspendStart datetime,  @SuspendEnd datetime, @AssignToDivision  int,  @AssignToLocation int , @AssignToStation int, @stationID int ,  @DivisionID int , @LocationID int
SET @CallPerHour  =0 
SET @CallPerDay =0 
SET @CallPerWeek =0
SET @CallPerMonth =0
SET @timeZone =0

select @timeZone =isnull( timezone,0) from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)


select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict , @DNIRestrict=DNIRestrict   , @InmateStatus	 = status,@InmateFirstName= FirstName,
			@InmateLastName = LastName,	@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0) ,  @TTY = isnull(TTY,0),
			 @SuspendStart = StartDate, @SuspendEnd = EndDate, @AssignToDivision = AssignToDivision,  @AssignToLocation= AssignToLocation,  @AssignToStation= AssignToStation
			From tblInmate  with(nolock)  where            PIN   = @PIN   and  facilityID =@facilityID 

If (@SuspendStart is not NULL AND @SuspendStart < @localtime and @SuspendEnd is NOT NULL and  @SuspendEnd > @localtime )
	SET @InmateStatus = 2

If(@AssignToDivision is not NULL  or   @AssignToLocation   is not NULL or  @AssignToStation    is not NULL )
 begin
 	Select @StationID       =phoneID,       @DivisionID  = DivisionID, @LocationID= LocationID  from tblANIs with(nolock) where ANIno = @fromNo
	if( @AssignToDivision is not NULL and @AssignToDivision <> @DivisionID) 
		SET @InmateStatus = 2
	If(   @AssignToLocation   is not NULL and   @AssignToLocation   <> @LocationID)
		SET @InmateStatus = 2
	If (  @AssignToStation    is not NULL  and  @AssignToStation    <>  @StationID)
		SET @InmateStatus = 2
 end

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
