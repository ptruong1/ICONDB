CREATE PROCEDURE [dbo].[p_verify_DayOfBirth] 
@facilityID	int,
@PIN		varchar(12),
@DD		varchar(2)
AS

if   (select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and substring(BirthDate,4,2) = @DD)  > 0
	return 1
else
  begin
	if   (select count(*) from tblInmate with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and substring(DOB,4,2) = @DD)  > 0
		return 1
	else
		return 0
 end
