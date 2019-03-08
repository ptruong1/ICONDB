
CREATE PROCEDURE [dbo].[p_insert_factility_11202017]
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
	@MaxCallTime smallint,
	@CollectWithCC bit,
	@timeZone smallint,
	@Probono bit,
	@OverlayOpt bit,
	@TYYOpt bit,
	@CommOpt bit,
	@DID char(10),
	@AcctExeID tinyint,
	@AcctRepID tinyint
	
)
AS
	SET NOCOUNT OFF;
Declare @AMT tinyint
Declare  @return_value int, @nextID int, @ID int, @tblFacility nvarchar(32) ;
SET  @AMT =0
Select @AMT = AMT from tblTimezone with(nolock) where ZoneCode = @timeZone;
IF @Phone in (SELECT Phone FROM tblFacility with(nolock) )
	BEGIN
		SET @FacilityID = -1;
		RETURN;
	END
ELSE
	BEGIN
		
		EXEC   @return_value = p_create_nextID 'tblFacility', @nextID   OUTPUT
		set           @ID = @nextID ; 
		INSERT INTO [tblFacility] ([FacilityID], [groupID] ,[Location], [Address], [City], [State], [Phone], [Zipcode], [ContactName], [ContactPhone], [ContactEmail], [IPaddress], [logo], [AgentID], [RateplanID], 
		[SurchargeID], [LibraryCode],[English], [Spanish], [French], [LiveOpt], [RateQuoteOpt], [PINRequired], [DebitOpt], [IncidentReportOpt], [BlockCallerOpt], [PromptFileID], [tollFreeNo],
		 [DayTimeRestrict], [UserName], [ModifyDate], MaxCallTime, CollectWithCC, timezone, Probono, OverlayOpt, TYYOpt, CommOpt, DID, AcctExeID, AcctRepID)
 
VALUES
 
		(@ID, @ID, @Location, @Address, @City, @State, @Phone, @ZipCode, @ContactName, @ContactPhone, @ContactEmail, @IPaddress, @logo, @AgentID, @RateplanID,
		 @SurchargeID, @LibraryCode, @English, @Spanish, @French, @LiveOpt, @RateQuoteOpt, @PINRequired, @DebitOpt, @IncidentReport, @BlockCaller, @PromptFileID, @tollFreeNo,
		 @DayTimeRestrict, @UserName, getdate(), @MaxCallTime, @CollectWithCC, @AMT,@Probono, @OverlayOpt,@TYYOpt, @CommOpt, @DID, @AcctExeID, @AcctRepID);

		SET @FacilityID = @ID;
		
		INSERT tblprompt (PromptFileID , [Descipt])  Values(@FacilityID, @Location) ;

		RETURN;
	END

--Declare @AMT tinyint
--SET  @AMT =0
--Select @AMT = AMT from tblTimezone with(nolock) where ZoneCode = @timeZone;
--IF @Phone in (SELECT Phone FROM tblFacility with(nolock) )
--	BEGIN
--		SET @FacilityID = -1;
--		RETURN;
--	END
--ELSE
--	BEGIN
--		INSERT INTO [tblFacility] ([Location], [Address], [City], [State], [Phone], [Zipcode], [ContactName], [ContactPhone], [ContactEmail], [IPaddress], [logo], [AgentID], [RateplanID], 
--		[SurchargeID], [LibraryCode],[English], [Spanish], [French], [LiveOpt], [RateQuoteOpt], [PINRequired], [DebitOpt], [IncidentReportOpt], [BlockCallerOpt], [PromptFileID], [tollFreeNo],
--		 [DayTimeRestrict], [UserName], [ModifyDate], MaxCallTime, CollectWithCC, timezone, Probono, OverlayOpt, TYYOpt, CommOpt, DID, AcctExeID, AcctRepID)
 
--VALUES
 
--		(@Location, @Address, @City, @State, @Phone, @ZipCode, @ContactName, @ContactPhone, @ContactEmail, @IPaddress, @logo, @AgentID, @RateplanID,
--		 @SurchargeID, @LibraryCode, @English, @Spanish, @French, @LiveOpt, @RateQuoteOpt, @PINRequired, @DebitOpt, @IncidentReport, @BlockCaller, @PromptFileID, @tollFreeNo,
--		 @DayTimeRestrict, @UserName, getdate(), @MaxCallTime, @CollectWithCC, @AMT,@Probono, @OverlayOpt,@TYYOpt, @CommOpt, @DID, @AcctExeID, @AcctRepID);

--		SET @FacilityID = @@IDENTITY;
		
--		INSERT tblprompt (PromptFileID , [Descipt])  Values(@FacilityID, @Location) ;

--		RETURN;
--	END

