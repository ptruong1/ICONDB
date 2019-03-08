CREATE PROCEDURE [dbo].[p_get_facility_by_stateID_for_mobile](@StateID smallint)
as
begin
	select FacilityID, Location from tblFacility with(nolock) where  [status] =1 and  [State]=(select StateCode from tblStates with(nolock) where StateID=@StateID);
end
