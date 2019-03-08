CREATE PROCEDURE [dbo].[p_verify_first4BookingID]
@facilityID	int,
@PIN		varchar(12),
@bookID4	varchar(4)
AS

if(select count(*) from tblInmateInfo with(nolock)  where  PIN = @PIN and  facilityID = @facilityID   and Left(BookingNo ,4) = @bookID4)  > 0
	return 1
else
	return 0
