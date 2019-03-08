

CREATE FUNCTION dbo.fn_getCallsPerMonthByPIN (@PIN varchar(12), @Currenttime datetime)
RETURNS int  AS  
BEGIN 
	Declare  @calls int
	select  @calls = count(*) from tblcallsbilled  with(nolock) where   datepart(m, RecordDate ) =   datepart(m, @Currenttime)
				    and  datepart(yy, RecordDate ) =   datepart(yy, @Currenttime )  and pin =@PIN
	

	return     @calls
END



