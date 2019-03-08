
CREATE PROCEDURE [dbo].[p_select_users_by_facilityID_v1]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;

DECLARE @tempTable TABLE(UserID varchar(20) NOT NULL, authID int NOT NULL,LastName varchar(25) Null, Status varchar(10),RoleDescript varchar(25) Null, inputdate smalldatetime Null);

INSERT INTO @tempTable (UserID, authID, LastName, Status,RoleDescript,inputdate)
SELECT        P.UserID, 
			  P.authID,
		      P.LastName, 
		      Descrip as Status,
			  (select RoleDescript from tblUserRole U where p.authID = u.RoleAuthID) as RoleDescript ,
			  P.inputdate  
FROM            tblUserprofiles  P
				INNER JOIN tblAuthUsers A ON P.authID = A.AuthID
		INNER JOIN tblStatus S ON P.Status = S.StatusID	
WHERE facilityID = @FacilityID

update @tempTable set RoleDescript = 'User Defined' where RoleDescript is null
select * from @tempTable
order by inputdate desc
