CREATE PROCEDURE [dbo].[SELECT_InmateInfoByPIN]
(
	@PIN varchar(12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;
SELECT BookingNo, PIN, FullName, BirthDate, BookingDate, BookingTime
 FROM [tblInmateInfo] 
WHERE (([FacilityID] = @FacilityID) AND ([PIN] = @PIN)) 
ORDER BY [BookingNo] DESC
