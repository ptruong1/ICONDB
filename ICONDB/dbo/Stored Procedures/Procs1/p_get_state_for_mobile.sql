CREATE PROCEDURE [dbo].[p_get_state_for_mobile] @CountryID smallint
as
begin
	
	select StateID, StateName from tblStates where CountryID =@CountryID
end
