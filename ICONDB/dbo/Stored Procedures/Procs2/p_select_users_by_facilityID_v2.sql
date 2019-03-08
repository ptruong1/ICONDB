
CREATE PROCEDURE [dbo].[p_select_users_by_facilityID_v2]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
	declare @oldRole varchar(25)
	set @oldRole = 'Old role'
SELECT        P.UserID, 
		      P.LastName, 
		      S.Descrip as Status,
			  (select RoleDescript from tblUserRole U where p.authID = u.RoleAuthID) as RoleDescript,
			  P.AuthID
		     
FROM            tblUserprofiles  P
				INNER JOIN tblAuthUsers A ON P.authID = A.AuthID
		INNER JOIN tblStatus S ON P.Status = S.StatusID
		
WHERE P.facilityID = @FacilityID
ORDER BY P.inputdate DESC
