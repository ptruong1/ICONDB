

CREATE PROCEDURE [dbo].[SELECT_FacilityByID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        FacilityID, Location, Address, City, State, Phone, Zipcode, ContactName, ContactPhone, ContactEmail, IPaddress, logo, AgentID, RateplanID, SurchargeID, LibraryCode, 
                         inputdate, English, Spanish, French, LiveOpt, RateQuoteOpt, PromptFileID, tollFreeNo, DayTimeRestrict, MaxCallTime, Username, modifyDate
FROM            tblFacility   with(nolock)
WHERE FacilityID = @FacilityID


