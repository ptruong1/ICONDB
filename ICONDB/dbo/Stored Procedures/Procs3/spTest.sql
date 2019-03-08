CREATE proc spTest @countryID int
as
select * from tblStates where CountryID = @countryID