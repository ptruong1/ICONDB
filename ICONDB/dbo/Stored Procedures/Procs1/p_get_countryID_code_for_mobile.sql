CREATE proc p_get_countryID_code_for_mobile @countryName nvarchar(100)
as
begin
  select CountryID, Code from tblCountryCode where CountryName=@countryName;
end;