CREATE PROCEDURE [dbo].[p_verify_YearOfBirth] 
@facilityID	int,
@PIN		varchar(12),
@YYYY		varchar(4)
AS

if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and right(BirthDate,4) = @YYYY)  > 0
	return 1
else
 begin
	if(select count(*) from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and right(DOB,4) = @YYYY)  > 0
		return 1
	else
		return 0
 end
