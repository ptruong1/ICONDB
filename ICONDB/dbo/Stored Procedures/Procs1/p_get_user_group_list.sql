﻿

CREATE PROCEDURE [dbo].[p_get_user_group_list]
@agentID int,
@UserGroupID int,
@MasterUserGroupID int
AS
if (@agentID =1)
	begin
	select distinct B.UserGroupID, UsergroupName
		from tblUserGroupFacility A join tblUserGroup B on A.UserGroupID = B.UserGroupID
	end
else
	begin
		if (@MasterUserGroupID = @UserGroupID)
		begin
			select distinct B.UserGroupID, UsergroupName
			from tblUserGroupFacility A join tblUserGroup B on A.UserGroupID = B.UserGroupID
			where AgentID = @AgentID  -- and MasterUserGroupID= @MasterUserGroupID
			order by UsergroupName asc;
		end
		else
			begin
				select distinct B.UserGroupID, UsergroupName
				from tblUserGroupFacility A Left join tblUserGroup B on A.UserGroupID = B.UserGroupID
				where AgentID = @AgentID and MasterUserGroupID= @MasterUserGroupID and A.UserGroupID =@UserGroupID
				Union
				select distinct B.UserGroupID, UsergroupName
				from tblUserGroupFacility A  join tblUserGroup B on A.UserGroupID = B.UserGroupID
				where AgentID = @AgentID and MasterUserGroupID=  @UserGroupID 
				order by UsergroupName asc;
			end
end



  



