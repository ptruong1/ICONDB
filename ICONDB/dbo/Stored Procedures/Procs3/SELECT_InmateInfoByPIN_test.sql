CREATE PROCEDURE [dbo].[SELECT_InmateInfoByPIN_test]
(
	@PIN varchar(12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;
SELECT BookingNo, PIN, FullName, BirthDate,isnull( BookingDate,'NA') as BookingDate, isnull(BookingTime,'NA') as bookingTime
 FROM [tblInmateInfo] 
WHERE ((FacilityID = @FacilityID) AND (PIN = @PIN)) 
--ORDER BY ArrestDate DESC, ArrestTime DESC
