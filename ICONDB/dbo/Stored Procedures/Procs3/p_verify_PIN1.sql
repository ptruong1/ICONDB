
CREATE PROCEDURE [dbo].[p_verify_PIN1]
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

Declare  @i int , @DateTimeRestrict  bit,    @localtime  smalldatetime,   @day int,   @h  int
Set  @localtime = getdate()
SET @day = datepart(dw, @localtime)
SET @h = datepart(hh, @localtime)

IF( select count(*)   From tblInmate  with(nolock)  where            PIN   = @PIN  and Status =1) > 0
 Begin
	select  @inmateID=   InmateID, @AlertEmail=isnull(AlertEmail,''),  @AlertPage =isnull( AlertPage,''), @AlertPhone= isnull(AlertPhone,'') , @DateTimeRestrict = DateTimeRestrict    
			From tblInmate  with(nolock)  where            PIN   = @PIN  and Status =1

	IF ( @DateTimeRestrict = 1) 
	      IF( select count(*) from tblPINTimeCall with(nolock) where PIN =@PIN and days = @day  and  hours & power(2, @h) >0) > 0
			Return -1
  End
Else 
 Begin
	EXEC  p_insert_unbilled_calls   '','',  @fromno ,'' ,'', 6 ,@PIN	,0 ,@facilityID	,@userName, '', @projectcode
  	Return -2
 End

