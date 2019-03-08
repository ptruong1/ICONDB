

CREATE PROCEDURE [dbo].[p_get_user_defined_roles_by_UserID]
@facilityID int,
@UserID varchar(20)
AS

select FacilityID, RoleAuthID,  RoleDescript from tblUserRole where facilityID =-1
union 
select FacilityID, RoleAuthID,  RoleDescript from tblUserRole where facilityID =@facilityID
union 
select facilityID, authID as RoleAuthID, 'User Defined' as RoleDescript  from tblUserprofiles where FacilityID= @facilityID and UserID=@UserID


  



