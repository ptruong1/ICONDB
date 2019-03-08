

create PROCEDURE [dbo].[p_get_user_defined_roles_Only_by_Facility]
@facilityID int
AS

select FacilityID, RoleAuthID,  RoleDescript from tblUserRole where facilityID =-1
union 
select FacilityID, RoleAuthID,  RoleDescript from tblUserRole where facilityID =@facilityID



  



