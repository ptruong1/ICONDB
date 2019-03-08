

CREATE PROCEDURE [dbo].[p_get_blackout_dates]
@facilityID int
AS
Begin
	select   FacilityID, HolidayDate, Descript
	from tblholiday
	where FacilityID = @facilityID
	order by HolidayDate asc
end

  



