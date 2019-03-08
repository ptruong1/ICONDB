

CREATE FUNCTION dbo.fn_getCallsPerMonthByPIN_facility (@PIN varchar(12), @Currenttime datetime, @facilityID int )
RETURNS int  AS  
BEGIN 
	Declare  @calls int
	select  @calls = count(*) from tblcallsbilled  with(nolock) where  datepart(mm,recordDate) =datepart(mm,@Currenttime )  and pin =@PIN  and facilityID = @facilityID
	

	return     @calls
END


