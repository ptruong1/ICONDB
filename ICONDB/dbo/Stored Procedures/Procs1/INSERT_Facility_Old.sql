




CREATE PROCEDURE [dbo].[INSERT_Facility_Old]
(
	@FacilityID int OUTPUT,
	@Location varchar(50),
	@Address varchar(50),
	@City varchar(20),
	@State char(2),
	@Phone char(10),
	@ZipCode varchar(10),
	@ContactName varchar(50),
	@ContactPhone varchar(10),
	@ContactEmail varchar(30),
	@IPaddress varchar(15),
	@logo varchar(30),
	@AgentID int,
	@RateplanID varchar(5),
	@SurchargeID varchar(5),
	@LibraryCode varchar(2),
	@English bit,
	@Spanish bit,
	@French bit,
	@LiveOpt bit,
	@RateQuoteOpt bit,
	@PINRequired bit,
	@DebitOpt bit,
	@IncidentReport bit,
	@BlockCaller bit,
	@PromptFileID smallint,
	@tollFreeNo char(10),
	@DayTimeRestrict bit,
	@UserName varchar(20),
	@MaxCallTime smallint
)
AS
	SET NOCOUNT OFF;
IF @Phone in (SELECT Phone FROM tblFacility)
	BEGIN
		SET @FacilityID = -1;
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblFacility] ([Location], [Address], [City], [State], [Phone], [Zipcode], [ContactName], [ContactPhone], [ContactEmail], [IPaddress], [logo], [AgentID], [RateplanID], [SurchargeID], [LibraryCode],[English], [Spanish], [French], [LiveOpt], [RateQuoteOpt], [PINRequired], [DebitOpt], [IncidentReportOpt], [BlockCallerOpt], [PromptFileID], [tollFreeNo], [DayTimeRestrict], [UserName], [ModifyDate], MaxCallTime) VALUES (@Location, @Address, @City, @State, @Phone, @ZipCode, @ContactName, @ContactPhone, @ContactEmail, @IPaddress, @logo, @AgentID, @RateplanID, @SurchargeID, @LibraryCode, @English, @Spanish, @French, @LiveOpt, @RateQuoteOpt, @PINRequired, @DebitOpt, @IncidentReport, @BlockCaller, @PromptFileID, @tollFreeNo, @DayTimeRestrict, @UserName, getdate(), @MaxCallTime);
		SET @FacilityID = @@IDENTITY;
		insert tblInmate (InmateID ,    CaseID  ,    LastName    ,   FirstName ,MidName ,   Status,FacilityId, pin )
		values( '0','0','NA','NA','',2, @FacilityID,'0')
		RETURN;
	END
