CREATE PROCEDURE [dbo].[p_get_InmateInfo_Web_service]
@PIN  varchar(12),
@fromNo	char(10),
@facilityID	int, 
@userName	varchar(23)
 AS
SET nocount on
Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int  ,@timeZone smallint, @CallPerHour smallint, @CallPerDay smallint , @CallPerWeek smallint, @CallPerMonth smallint ,@TTY tinyint
Declare @DNIRestrict    tinyint, @AlertEmail        varchar(25),@AlertPage  	Varchar(25)  ,@AlertPhone     Varchar(25),@InmateFirstName	 Varchar(25),@InmateLastName	varchar(25) ,
	@InmateStatus		tinyint ,@Register tinyint ,@AcessAllow  smallint,  @inmateID varchar(12), @AccuPIN tinyint, @BioMetric tinyint
SET @CallPerHour  =0 
SET @CallPerDay =0 
SET @CallPerWeek =0
SET @CallPerMonth =0
SET @timeZone =0
SET @Register = 0
SET @AcessAllow  = 1
SET  @InmateStatus = 0
set @AlertPhone =''
set @AlertPage=''
set  @TTY =0
set @AccuPIN = 0
set  @BioMetric = 0
select @timeZone =isnull( timezone,0) from tblfacility with(nolock) where facilityID =@facilityID
Set  @localtime = dateadd(hh, @timeZone,getdate() )
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)


select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict , @DNIRestrict=DNIRestrict   , @InmateStatus	 = status,@InmateFirstName= FirstName,
			@InmateLastName = LastName,	@CallPerHour  = Isnull(MaxCallPerHour,0) , @CallPerDay= isnull( MaxCallPerDay,0),  @CallPerWeek =isnull(  MaxCallPerWeek,0),  @CallPerMonth =isnull( MaxCallPerMonth ,0) ,  @TTY = isnull(TTY,0),
			@Register = isnull(NameRecorded,0)  From tblInmate  with(nolock)  where            PIN   = @PIN   and  facilityID =@facilityID and Status=1
If( @InmateStatus=1)
  Begin

	IF ( @DateTimeRestrict = 1) 
	 Begin
	      IF( select count(*) from tblPINTimeCall with(nolock) where PIN =@PIN and days = @day  and facilityID = @facilityID  and  hours & power(2, @h) >0) > 0
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
			Return -1
		End
	 End
	If ( @CallPerHour >0 )
	 Begin
		--If( dbo.fn_getCallsPerHourByPIN (@PIN, @localtime) > @CallPerHour   )
		 If (dbo.fn_getCallsPerHourByPIN_Facility (@PIN, @localtime, @facilityID)  > @CallPerHour   )
		 Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
			Return -1
		End
	 end
	If ( @CallPerDay >0 )
	 Begin
		--If(  dbo.fn_getCallsPerDayByPIN (@PIN, @localtime) >  @CallPerDay   )
		If(  dbo.fn_getCallsPerDayByPIN_Facility (@PIN, @localtime,  @facilityID) >  @CallPerDay   )
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
			Return -1
		End
	 end
	If ( @CallPerWeek >0 )
	 Begin
		--If(  dbo.fn_getCallsPerWeekByPIN (@PIN, @localtime) >  @CallPerWeek   ) 
		If(  dbo.fn_getCallsPerWeekByPIN_facility (@PIN, @localtime,@facilityID ) >  @CallPerWeek   ) 
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
			Return -1
		End
	 end
	If ( @CallPerMonth >0 )
	 Begin
		--If(  dbo.fn_getCallsPerMonthByPIN (@PIN, @localtime) >  @CallPerMonth   )  
		If(  dbo.fn_getCallsPerMonthByPIN_facility (@PIN, @localtime,@facilityID ) >  @CallPerMonth   )  
		Begin
			EXEC  p_insert_unbilled_calls2   '','',  @fromno ,'' ,'', 9 ,@PIN	,0 ,@facilityID	,@userName, '', '','',@localtime
			Return -1
		End
	 end
	
  End
Else 
 Begin
	EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 6 ,@PIN	,0 ,@facilityID	,@userName, '', ''
  	SET @AcessAllow = 0
 End

Select  @inmateID as InmateID, @AcessAllow as AccessAllow , @InmateFirstName as FirstName,@InmateLastName as LastName , @InmateStatus  as Status ,@Register as Register  , @DNIRestrict   as DNIRestrict ,
  	@AlertEmail      as  AlertEmail   ,   @AlertPhone  as AlertPhone,    @TTY  as  TTY, @AccuPIN As AccuPIN,   @BioMetric  as BioMetric
