
CREATE PROCEDURE [dbo].[SELECT_Facilities_ForUpdate]
( 
	@FacilityID int 
)
AS
	SET NOCOUNT ON;
SELECT  F.FacilityID
      ,[Location]
      ,[Address]
      ,[City]
      ,[State]
      ,[Zipcode]
      ,[Phone]
      ,[ContactName]
      ,[ContactPhone]
      ,[ContactEmail]
      ,[IPaddress]
      ,[logo]
      ,[AgentID]
      ,[RateplanID]
      ,[SurchargeID]
      ,[LibraryCode]
      ,[inputdate]
      ,[English]
      ,[Spanish]
      ,[French]
      ,[LiveOpt]
      ,[RateQuoteOpt]
      ,[PromptFileID]
      ,[tollFreeNo]
      ,[DayTimeRestrict]
      ,[UserName]
      ,F.modifyDate
      ,[MaxCallTime]
      ,[DebitOpt]
      ,[PINRequired]
      ,[IncidentReportOpt]
      ,[BlockCallerOpt]
      ,[CollectWithCC]
      ,[timeZone]
      ,[Probono]
      ,[OverLayOpt]
      ,[TYYOpt]
      ,[CommOpt]
      ,[DID]
      ,[status]
      ,[BlockedByHour]
      ,[flatform]
      ,[RecordOpt]
      ,isnull(AccuPIN,0) as AccuPIN
      ,isnull(BioMetric,0) as BioMetric
      ,isnull(AutoPin,0) as AutoPin
      ,isnull(NameRecord,0) as NameRecord
      ,ISNULL(FormsOpt,0) as FormsOpt
      
FROM            tblFacility  F with(nolock)
left join tblFacilityOption O with(nolock) on F.FacilityID = O.facilityID
Where F.FacilityID = @facilityID

