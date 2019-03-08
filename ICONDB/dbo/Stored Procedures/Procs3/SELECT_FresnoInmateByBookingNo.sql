
CREATE PROCEDURE [dbo].[SELECT_FresnoInmateByBookingNo]
(
	@BookingNo varchar(12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;
SELECT [BookingNo], [PIN], [FacilityID], [FullName], [BirthDate], [Sex], [Race], [HairColor], [EyeColor], [Height], [Weight], [Age], [ArrestDate], [ArrestTime], [BookingDate], [BookingTime], [AgencyCaseNo], [Agency], [Location], [HoldType], [HoldStartDate] FROM [tblInmateInfo]
WHERE ([BookingNo] = @BookingNo) AND  FacilityId = @FacilityId

