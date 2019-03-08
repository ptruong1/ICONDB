
CREATE PROCEDURE [dbo].[p_create_ATAInfo01232017]

@ATAIP varchar(16),
@ATASubnet varchar(16),
@FacilityID int ,
@PriDNS varchar(16),
@SecDNS varchar(16),
@ProviderName varchar(150),
@ProviderEmail varchar(40),
@ProviderPhone varchar(10),
@ATAModel varchar(50),
@ATALocation varchar(50),
@TechSupportID int,
@Status bit,
@AlertID int
 AS
 
declare @AgentID  int
select @AgentID = AgentID from tblFacility where FacilityID = @FacilityID
Insert tblFacilityATAInfo
(
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
	TechSupportID,
	Status,
	AlertID
)

values
(
	@ATAIP,
	@ATASubnet,
	@FacilityID,
	@AgentID,
	@PriDNS,
	@SecDNS,
	@ProviderName,
	@ProviderEmail,
	@ProviderPhone,
	@ATAModel,
	@ATALocation,
	@TechSupportID,
	@Status,
	@AlertID
)

