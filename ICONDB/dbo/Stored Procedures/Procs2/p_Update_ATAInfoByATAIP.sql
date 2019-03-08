
CREATE PROCEDURE [dbo].[p_Update_ATAInfoByATAIP]

@ATAIP varchar(16),
@ATASubnet varchar(16),
@FacilityID int ,
@AgentID  int,
@PriDNS varchar(16),
@SecDNS varchar(16),
@ProviderName varchar(150),
@ProviderEmail varchar(40),
@ProviderPhone varchar(10),
@ATAModel varchar(50),
@ATALocation varchar(50),
@TechSupportID int,
@Status tinyint,
@AlertID int,
@USerIP varchar(25),
@UserID varchar(25)

 AS
	SET NOCOUNT OFF;
	Declare  @UserAction varchar(100),@ActTime datetime;

	UPDATE [tblFacilityATAInfo] SET
 
	[ATAIP] = @ATAIP, 
	[ATASubnet] = @ATASubnet,
	[PriDNS] = @PriDNS,
	[SecDNS] = @SecDNS,
	[ProviderName] = @ProviderName,
	[ProviderEmail] = @ProviderEmail,
	[ProviderPhone] = @ProviderPhone,
	[ATAModel] = @ATAModel,
	[ATALocation] = @ATALocation,
	[TechSupportId] = @TechSupportID,
	[Status] = @Status,
	[AlertID] = @AlertID

 From tblFacilityATAInfo 

where 	FacilityID = @FacilityID and
	AgentID = @AgentID and
	ATAIP = @ATAIP
SET  @UserAction =  'Edit ATA:' + @ATAIP;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

EXEC  INSERT_ActivityLogs3	@FacilityID ,21 ,@ActTime, 0,@ActTime ,@UserIP,@UserID,@UserAction ;
