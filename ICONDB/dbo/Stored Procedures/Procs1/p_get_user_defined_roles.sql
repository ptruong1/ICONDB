

CREATE PROCEDURE [dbo].[p_get_user_defined_roles]
@facilityID int

AS

select FacilityID, RoleAuthID,  RoleDescript from tblUserRole where facilityID =-1
union 
select FacilityID, RoleAuthID,  RoleDescript from tblUserRole where facilityID =1
union 
select 1 as FacilityID ,0 as RoleAuthID, 'User Defined' as RoleDescript  from tblUserRole --where FacilityID= @facilityID 
order by RoleDescript asc

  



