﻿


CREATE PROCEDURE [dbo].[UPDATE_Legacy_FacilityByID]
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
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
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
						[PromptFileID] = @PromptFileID, [tollFreeNo] = @tollFreeNo, 
						[DayTimeRestrict] = @DayTimeRestrict, [UserName] = @UserName,
						[modifyDate] = getdate(), [MaxCallTime] = @MaxCallTime, 
						[DebitOpt] = @DebitOpt, [IncidentReportOpt] = @IncidentReport,
						[BlockCallerOpt] = @BlockCaller, [PINRequired] = @PINRequired
WHERE ([FacilityID] = @FacilityID);


