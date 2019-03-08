CREATE PROCEDURE [dbo].[p_get_countryCode_for_mobile]
as
begin
	--select CountryID, (CountryName+ '-' + Code) as CountryName from tblCountryCode
	select CountryID, CountryName from tblCountryCode
end
