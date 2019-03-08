

create PROCEDURE [dbo].[p_get_facility_visit_allowed]
@facilityID int
AS
Begin
	select   FacilityID, VisitPerDay, VisitPerWeek, VisitPerMonth
	from tblVisitFacilityConfig
	where FacilityID = @facilityID
end

  



