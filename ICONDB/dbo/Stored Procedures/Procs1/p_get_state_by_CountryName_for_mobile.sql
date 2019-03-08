CREATE PROCEDURE [dbo].[p_get_state_by_CountryName_for_mobile] @CountryName smallint
as
begin
	declare @CountryID smallint
	select @CountryID= CountryID from tblCountryCode where CountryName =@CountryName
	select StateID, StateName from tblStates where CountryID =@CountryID
end
