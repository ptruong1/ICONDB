
CREATE PROCEDURE [dbo].[p_select_facility_fromAgent_user_groups]

( 
	@AgentID int,
	@UserGroupID int
)
AS
	--SET NOCOUNT ON;
	--Declare @FacilityID int, @Location varchar(50),@Address varchar(20), @City varchar(20), @State varchar(2), @Zipcode varchar(10)
	--SELECT        U.FacilityID, Location,  Address, City, State, Zipcode
	--FROM            tblFacility  F with(nolock)  inner join tblUserGroupFacility U with(nolock) on F.FacilityID= U.FacilityID
 --   WHERE  status =1 and U.AgentID=@AgentID and U.usergroupID =@UserGroupID
 --   ORDER BY U.FacilityID DESC

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
	
	SELECT        F.FacilityID, Location, Address, City, State, Zipcode, ContactName,  F.AgentID, groupID,
			      (Select count(*)  as [transcriptOpt] from tblFacilityOption  where   tblFacilityOption.FacilityID = F.FacilityID) as transcriptOpt,
			      (Select isnull (FormsOpt,0)  from tblFacilityOption where   tblFacilityOption.FacilityID = F.FacilityID) as FormsOpt
    FROM            tblFacility F with(nolock) inner join tblUserGroupFacility U on F.FacilityID =U.FacilityID
	WHERE F.AgentID = @AgentID  And status =1 and UserGroupID=@UserGroupID
	ORDER BY Location Asc

