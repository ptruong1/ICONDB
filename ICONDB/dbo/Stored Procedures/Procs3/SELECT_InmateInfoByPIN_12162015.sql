CREATE PROCEDURE [dbo].[SELECT_InmateInfoByPIN_12162015]
(
	@PIN varchar(12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;

Declare @InmateID varchar(12), @FullName varchar(50);
Select  @InmateID  =InmateID, @FullName = FirstName + ' ' + LastName from tblInmate with(nolock) where facilityID = @FacilityId and PIN = @PIN and [status]=1;

SELECT BookingNo, PIN,@FullName as FullName, [SSN], Address1, Zip, BirthDate, BookingDate, BookingTime
 FROM [tblInmateInfo]  with(nolock)
WHERE (([FacilityID] = @FacilityID) AND ([PIN] = @InmateID)) 
ORDER BY [BookingNo] DESC;
