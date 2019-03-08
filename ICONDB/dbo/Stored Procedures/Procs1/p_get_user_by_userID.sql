

CREATE PROCEDURE [dbo].[p_get_user_by_userID]
@UserID varchar(20),
@facilityID int
AS
select authID, UserID, LastName, FirstName   from tblUserprofiles where UserID =@UserID and FacilityID=@facilityID



  



