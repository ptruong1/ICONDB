
CREATE PROCEDURE [dbo].[SELECT_ATALiveStatus] 
(
@State varchar(2),
@facilityID int,	
@AgentID int
)
AS
	SET NOCOUNT ON;
If @State = ''
Begin

	SELECT        U.FacilityID, Location, ATAIP, ATASubnet, ATAlocation, B.Descrip
	FROM            tblFacilityATAInfo U   with(nolock)
	 INNER JOIN    tblFacility A  with(nolock) ON U.FacilityID = A.FacilityID
	INNER JOIN    tblStatus  B  with(nolock) ON U.Status = B.StatusID
	WHERE	U. AgentID = @AgentID
	Order by U.facilityID
End
else
If @facilityID = '-1'
Begin
	SELECT        U.FacilityID, Location, ATAIP, ATASubnet, ATAlocation, B.Descrip
	FROM            tblFacilityATAInfo U   with(nolock)
	 INNER JOIN    tblFacility A  with(nolock) ON U.FacilityID = A.FacilityID and A.State = @State
	INNER JOIN    tblStatus  B  with(nolock) ON U.Status = B.StatusID
	WHERE	U. AgentID = @AgentID
	Order by U.facilityID
End
else
Begin
	
	SELECT        U.FacilityID, Location, ATAIP, ATASubnet, ATAlocation, B.Descrip
	FROM            tblFacilityATAInfo U   with(nolock)
	 INNER JOIN    tblFacility A  with(nolock) ON U.FacilityID = A.FacilityID
	INNER JOIN    tblStatus  B  with(nolock) ON U.Status = B.StatusID
	WHERE	U. AgentID = @AgentID and U.facilityId = @facilityID 
	Order by U.facilityID
End

