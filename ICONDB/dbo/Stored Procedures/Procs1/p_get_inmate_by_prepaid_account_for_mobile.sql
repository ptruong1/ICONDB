CREATE proc p_get_inmate_by_prepaid_account_for_mobile(@PhoneNo varchar(50), @FacilityID int)
as
begin
	declare @InmateID varchar(50)
	select @InmateID=InmateID from tblPrepaid where PhoneNo=@PhoneNo
	select InmateID, FirstName+space(1)+LastName as InmateName from tblInmate 
	where (InmateID=@InmateID) and (FacilityId=@FacilityID)
end