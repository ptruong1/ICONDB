


CREATE PROCEDURE [dbo].[p_Select_FreeCalls]
@GroupID int
AS

SET NOCOUNT ON;

		If (@GroupID = 74 or @GroupID = 75 or @GroupID =76 )		
			SELECT        PhoneNo, FacilityID, FirstName, LastName, Descript, Username,InputDate,GroupID
			FROM            tblFreePhones
			WHERE GroupID = 74 or GroupID = 75 or GroupID =76 
		else 
			SELECT        PhoneNo, FacilityID, FirstName, LastName, Descript, Username,InputDate, GroupID
			FROM            tblFreePhones
			WHERE groupID =@GroupID
	--end


