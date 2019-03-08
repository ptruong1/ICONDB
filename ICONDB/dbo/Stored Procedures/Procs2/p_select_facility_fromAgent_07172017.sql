
CREATE PROCEDURE [dbo].[p_select_facility_fromAgent_07172017]

( 
	@AgentID int
	
)
AS
	SET NOCOUNT ON;
	declare @FormsOpt int
	set @FormsOpt = 0

If @AgentID = 1
	SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,
					(Select count(*)  as [transcriptOpt] from tblFacilityOption 
					where   tblFacilityOption.FacilityID = tblFacility.FacilityID) as transcriptOpt,
					(Select isnull(FormsOpt,0) as FormsOpt from tblFacilityOption  
					where   tblFacilityOption.FacilityID = tblFacility.FacilityID) as FormsOpt 
FROM            tblFacility  with(nolock)

WHERE  status =1
	

ORDER BY FacilityID DESC

else

SELECT        FacilityID, Location, Address, City, State, Zipcode, ContactName,  AgentID,

		             (Select count(*)  as [transcriptOpt] from tblFacilityOption 
			where   tblFacilityOption.FacilityID = tblFacility.FacilityID) as transcriptOpt,
			(Select isnull(FormsOpt,0) as FormsOpt  from tblFacilityOption 
					where   tblFacilityOption.FacilityID = tblFacility.FacilityID) as FormsOpt
FROM            tblFacility  with(nolock)

WHERE AgentID = @AgentID  And status =1
	

ORDER BY Location Asc
