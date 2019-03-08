
CREATE PROCEDURE [dbo].[p_update_Facility_LegacySite06172016]
(
	@Location varchar(50),
	@Address varchar(50),
	@City varchar(20),
	@State char(2),
	@Zipcode varchar(10),
	@Phone char(10),
	@ContactName varchar(50),
	@ContactPhone varchar(10),
	@ContactEmail varchar(30),
	@AgentID int,
	@RateplanID varchar(5),
	@SurchargeID varchar(5),
	@LibraryCode varchar(2),
	@English bit,
	@Spanish bit,
	@French bit,
	@LiveOpt bit,
	@RateQuoteOpt bit,
	@PromptFileID smallint,
	@tollFreeNo char(10),
	@DayTimeRestrict bit,
	@UserName varchar(20),
	@MaxCallTime smallint,
	@DebitOpt bit,
	@IncidentReport bit,
	@BlockCaller bit,
	@PINRequired bit,
	@FacilityID int,
	@CollectWithCC bit,
	@timeZone smallint,
	@Probono bit,
	@OverlayOpt bit,
	@TYYOpt bit,
	@CommOpt bit,
	@DID char(10),
	@Status int,
	@AcctExeID tinyint,
	@AcctRepID tinyint,
	@RecordOpt varchar(1)
)
AS
	
SET NOCOUNT OFF;
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 

IF @Phone in (SELECT Phone FROM tblFacility WHERE FacilityID <> @FacilityID)
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN		
		UPDATE [tblFacility] SET [Location] = @Location, 
						[Address] = @Address, 
						[City] = @City, [State] = @State, 
						[Zipcode] = @Zipcode, [Phone] = @Phone, 
						[ContactName] = @ContactName, [ContactPhone] = @ContactPhone, 
						[ContactEmail] = @ContactEmail, [AgentID] = @AgentID, 
						[RateplanID] = @RateplanID, [SurchargeID] = @SurchargeID, 
						[LibraryCode] = @LibraryCode,[English] = @English, 
						[Spanish] = @Spanish, [French] = @French, 
						[LiveOpt] = @LiveOpt, [RateQuoteOpt] = @RateQuoteOpt, 
						[PromptFileID] = @PromptFileID,-- [tollFreeNo] = @tollFreeNo, 
						[DayTimeRestrict] = @DayTimeRestrict, [UserName] = @UserName,
						[modifyDate] = getdate(), [MaxCallTime] = @MaxCallTime, 
						[DebitOpt] = @DebitOpt, [IncidentReportOpt] = @IncidentReport,
						[BlockCallerOpt] = @BlockCaller, [PINRequired] = @PINRequired,
						[CollectWithCC] = @CollectWithCC,
						[timeZone] = @timeZone,
						[Probono] = @Probono,
						[OverlayOpt] = @OverlayOpt,
						[TYYOpt] = @TYYOpt,
						[CommOpt] = @CommOpt,
						[DID] = @DID,
						[AcctExeID] =@AcctExeID,
						[AcctRepID] =@AcctRepID,
						[RecordOpt] = @RecordOpt,
						[status] =@Status
		WHERE ([FacilityID] = @FacilityID);
		SET  @UserAction =  'Modify Facility Configure ' ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,6,@ActTime ,0,@UserName ,'', @FacilityID  ,@UserAction ;  
	END


