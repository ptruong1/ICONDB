create PROCEDURE [dbo].[p_select_InmateBookingByInmateID]
(
	@InmateID varchar(12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;
SELECT BookingNo, A.PIN, FullName, [SSN], Address1, Zip, BirthDate, BookingDate, BookingTime
 FROM  tblInmate A  with(nolock) INNER JOIN [tblInmateInfo] B 
	ON A.FacilityID = B.FacilityId and A.PIN = B.PIN
WHERE ((A.FacilityId = @FacilityID) AND (A.InmateID = @InmateID)) 
ORDER BY [BookingNo] DESC