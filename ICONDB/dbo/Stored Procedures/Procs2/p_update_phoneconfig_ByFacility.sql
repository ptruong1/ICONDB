
CREATE PROCEDURE [dbo].[p_update_phoneconfig_ByFacility]
(
	@FacilityID int,
	@UserName varchar(20),
	@userIP varchar (16),
	
	@English bit,
	@Spanish bit,
	@otherlanguage bit,
	
	@DayTimeRestrict bit,
	@PINRequired bit,
	@DebitOpt bit,
		
	@NameRecord bit,
	@FormsOpt bit,
	@CollectWithCC bit,
	
	@AccuPIN bit,
	@BioMetric bit,
	@AutoPIN bit,
	
	@MaxCallTime smallint,
	@timeZone smallint,	
	@Status int
	
)
AS
	
SET NOCOUNT OFF;
UPDATE [tblFacility] 
		SET [English] = @English, 
			[Spanish] = @Spanish, 
			[French] = @otherlanguage, 
			[DayTimeRestrict] = @DayTimeRestrict,
			[UserName] = @UserName,
			[modifyDate] = getdate(),
			[MaxCallTime] = @MaxCallTime, 
			[DebitOpt] = @DebitOpt, 
			[PINRequired] = @PINRequired,
			[CollectWithCC] = @CollectWithCC,
			[timeZone] = @timeZone,
			[status] = @Status
	WHERE ([FacilityID] = @FacilityID);

UPDATE [leg_Icon].[dbo].[tblFacilityOption]
	   SET 
		  [AccuPIN] = @AccuPIN
		  ,[BioMetric] = @BioMetric
		  ,[AutoPin] = @AutoPin
		  ,[NameRecord] = @NameRecord
		  ,[FormsOpt] = @FormsOpt
      
	WHERE FacilityID = @facilityID
	
declare  @UserAction varchar(100), @ActTime datetime      
EXEC [p_get_facility_time] @FacilityID ,@ActTime OUTPUT ;
SET  @UserAction =  'Update Phone Config FacilityId ';
EXEC  INSERT_ActivityLogs3	@FacilityID ,6,@ActTime ,0,@UserName ,@userIP, @FacilityID,@UserAction ; 

