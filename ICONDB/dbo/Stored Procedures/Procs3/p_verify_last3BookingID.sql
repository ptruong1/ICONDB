CREATE PROCEDURE [dbo].[p_verify_last3BookingID]
@facilityID	int,
@PIN		varchar(12),
@bookID3	varchar(3)
AS

if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and right(BookingNo ,3) = @bookID3)  > 0
	return 1
else
	return 0
