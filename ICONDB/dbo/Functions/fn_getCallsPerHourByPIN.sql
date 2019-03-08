

CREATE FUNCTION dbo.fn_getCallsPerHourByPIN (@PIN varchar(12), @Currenttime datetime)
RETURNS int  AS  
BEGIN 
	Declare  @calls int
	select  @calls = count(*) from tblcallsbilled  with(nolock) where    datepart(ww, RecordDate ) =   datepart(ww, @Currenttime)
				  				  and  datepart(yy, RecordDate ) =   datepart(yy, @Currenttime )   
								  and  datepart(dw, RecordDate ) =   datepart(dw, @Currenttime ) 
								  and  datepart(hh, RecordDate ) =   datepart(hh, @Currenttime ) 
								  and pin =@PIN
	

	return     @calls
END






