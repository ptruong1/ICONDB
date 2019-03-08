CREATE PROCEDURE [dbo].[p_get_visitor_info_for_mobile] @account varchar(50), @facilityID int
as
begin
	select EndUserID, FacilityID, VisitorID, VFirstName, VLastName, Email, Approved from tblVisitors where EndUserID = @account and FacilityID = @facilityID
end
