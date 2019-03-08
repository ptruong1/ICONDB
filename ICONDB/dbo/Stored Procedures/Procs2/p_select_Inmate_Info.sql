CREATE PROCEDURE [dbo].[p_select_Inmate_Info]
(
	@InmateID varchar(12),
	@FacilityId int
)
AS
SET NOCOUNT ON;
Declare @PIN varchar(12), @fullName varchar(50);
Select @PIN = pin,  @fullName  = firstname +' ' + lastName from tblinmate with(nolock) where facilityID = @facilityID and inmateID = @InmateID;
SELECT BookingNo,BookingDate,BirthDate,Sex,Race, Address1,City, Zip,[State], SSN, @fullName as fullName
	FROM [tblInmateInfo] 
	WHERE (([FacilityID] = @FacilityID) AND ([PIN] =  @PIN )) 
	ORDER BY [BookingNo] DESC;
