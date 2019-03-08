
CREATE PROCEDURE [dbo].[Select_ATAIP_For_Update]

@FacilityID int ,
@AgentID  int,
@ATAIP varchar(16)

 AS

Select 

	ATAIP,
	ATASubnet,
	FacilityID,
	AgentID,
	PriDNS,
	SecDNS,
	ProviderName,
	ProviderEmail,
	ProviderPhone,
	ATAModel,
	ATALocation,
	isnull(TechSupportID,'1') as TechSupportID,
	Status,
	AlertID

From tblFacilityATAInfo 
where 	FacilityID = @FacilityID and
	AgentID = @AgentID and
	ATAIP = @ATAIP

