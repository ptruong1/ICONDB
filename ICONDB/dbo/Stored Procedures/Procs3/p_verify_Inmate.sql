
CREATE PROCEDURE [dbo].[p_verify_Inmate]
@InmateID	bigint,
@DNIRestrict    tinyint OUTPUT,
@AlertEmail        varchar(25) OUTPUT,
@AlertPage  	Varchar(25)  OUTPUT ,
@AlertPhone     Varchar(25)  OUTPUT
 AS
Declare  @DateRestrict smallint,  @TimeRestrict  tinyint,  @hour  int,  @day int,  @localtime  datetime
set @localTime = getdate() --- change later
SET  @DateRestrict = -1
SET @TimeRestrict =0
SET @day =  datepart(dw,@localTime ) 
SET  @hour = datepart(hh,@localTime ) 

select  @DateRestrict = isnull(DateTimeRestrict,0),  @DNIRestrict  = isnull(DNIRestrict,0) , @AlertEmail  = AlertEmail , @AlertPage  = AlertPage , @AlertPhone =AlertPhone
		from  tblInmate with(nolock)  where InmateID = @InmateID and Status =1

IF( @DateRestrict  =1 )
	IF( select count(*) from tblTimeCall with(nolock) where inmateID = @InmateID and days = @day  and  hours & power(2, @hour) >0) > 0
			Return -1
	else
			return 0
else IF( @DateRestrict  =0 )
	Return 0
else
	return -2

