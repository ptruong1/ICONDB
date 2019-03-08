CREATE PROCEDURE [dbo].[p_verify_monthOfBirth] 
@facilityID	int,
@PIN		varchar(12),
@MM		varchar(2)
AS

if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and left(BirthDate,2) = @MM)  > 0
	return 1
else
 begin
	if(select count(*) from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and left(DOB,2) = @MM)  > 0
		return 1
	else
		return 0
 end
