CREATE PROCEDURE [dbo].[p_select_facility_fromAgent_12052018]

( 
	@AgentID int,
	@UserGroupID int
)
AS
	SET NOCOUNT ON;
If @AgentID = 1
	SELECT        F.FacilityID, Location, Address, City, State, Zipcode, ContactName,  F.AgentID, groupID,
					(Select count(*)  as [transcriptOpt] from tblFacilityOption 
					where   tblFacilityOption.FacilityID = F.FacilityID) as transcriptOpt,
					(Select isnull (FormsOpt,0) from tblFacilityOption  
					where   tblFacilityOption.FacilityID = F.FacilityID) as FormsOpt 
	FROM            tblFacility F with(nolock) inner join tblUserGroupFacility U on F.FacilityID =U.FacilityID
	WHERE  status =1 and UserGroupID=@UserGroupID
	ORDER BY F.FacilityID DESC
else
	begin
		if @UserGroupID is null
		begin
			set @UserGroupID=1
		end
		SELECT        F.FacilityID, Location, Address, City, State, Zipcode, ContactName,  F.AgentID, groupID,
			      (Select count(*)  as [transcriptOpt] from tblFacilityOption  where   tblFacilityOption.FacilityID = F.FacilityID) as transcriptOpt,
			      (Select isnull (FormsOpt,0)  from tblFacilityOption where   tblFacilityOption.FacilityID = F.FacilityID) as FormsOpt
		 FROM            tblFacility F with(nolock) inner join tblUserGroupFacility U on F.FacilityID =U.FacilityID
		WHERE F.AgentID = @AgentID  And status =1  and UserGroupID=@UserGroupID
		ORDER BY Location Asc

	end
	
