
CREATE FUNCTION fn_getJulianDate (@currentDate  datetime)
RETURNS  char(3)
 AS  
BEGIN 
 
	Declare @firstDate varchar(10), @julianDate smallint, @jd  char(3)
	set @firstDate = '01/01/' + cast(datepart(yy,@currentDate) as char(4))
	SET @julianDate =  dateDiff(d,@firstDate,@currentDate) +1
	if(@julianDate <10)  SET @jd = '00' + CAST ( @julianDate as char(1))
	
	else  if(@julianDate <100  and  @julianDate >=10)  SET @jd = '0' + CAST ( @julianDate as char(2))
	else  SET  @jd =  CAST ( @julianDate as char(3))
	

 return    @jd 

END





