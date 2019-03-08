


CREATE PROCEDURE [dbo].[SELECT_FreeCalls]
(@FacilityID int)
AS

SET NOCOUNT ON;

If (@FacilityID = 74 or @FacilityID = 75 or @FacilityID =76 )
	
	SELECT        PhoneNo, FacilityID, FirstName, LastName, Descript, Username,InputDate
	FROM            tblFreePhones
	WHERE FacilityID = 74 or FacilityID = 75 or FacilityID =76 

else 

	SELECT        PhoneNo, FacilityID, FirstName, LastName, Descript, Username,InputDate
	FROM            tblFreePhones
	WHERE FacilityID = @FacilityID

