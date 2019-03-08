
create proc p_get_location_name(@computerName varchar(50))
as
begin
	select LocationName from tblVisitLocation where LocationID=(select LocationID from tblVisitPhone where ExtID=@computerName)
end
