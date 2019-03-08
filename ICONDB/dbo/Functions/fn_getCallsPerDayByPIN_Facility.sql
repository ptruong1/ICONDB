
CREATE FUNCTION dbo.fn_getCallsPerDayByPIN_Facility (@PIN varchar(12), @Currenttime datetime, @facilityID int)
RETURNS int  AS  
BEGIN 
	Declare  @calls int
	select  @calls = count(*) from tblcallsbilled  with(nolock) where facilityID =@facilityID and   dateDiff(d, RecordDate,@Currenttime  ) <1  and pin =@PIN
	

	return     @calls
END







