

CREATE FUNCTION dbo.fn_getCallsPerWeekByPIN_facility (@PIN varchar(12), @Currenttime datetime, @facilityID int)
RETURNS int  AS  
BEGIN 
	Declare  @calls int
	select  @calls = count(*) from tblcallsbilled  with(nolock) where    datepart(wk,recordDate) =datepart(wk,@Currenttime )  and pin =@PIN  AND facilityID = @facilityID
	

	return     @calls
END







