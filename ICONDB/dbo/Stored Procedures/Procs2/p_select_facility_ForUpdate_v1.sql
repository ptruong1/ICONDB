
create PROCEDURE [dbo].[p_select_facility_ForUpdate_v1]
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
      ,F.ContactPhone
      ,F.ContactEmail
      ,[IPaddress]
      ,[logo]
      ,[AgentID]
      ,[RateplanID]
      ,[SurchargeID]
      ,[LibraryCode]
      ,F.inputdate
      ,[English]
      ,[Spanish]
      ,[French]
      ,[LiveOpt]
      ,[RateQuoteOpt]
      ,[PromptFileID]
      ,[tollFreeNo]
      ,[DayTimeRestrict]
      ,F.UserName
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
      ,F.RecordOpt
      ,isnull(AccuPIN,0) as AccuPIN
      ,isnull(BioMetric,0) as BioMetric
      ,isnull(AutoPin,0) as AutoPin
      ,isnull(NameRecord,0) as NameRecord
      ,ISNULL(FormsOpt,0) as FormsOpt
      ,F.Status
      ,isnull(AcctExeID, 1) as AcctExeID
	  ,isnull(AcctRepID, 1) as AcctRepID
	  ,V.ContactEmail as VisitContactEmail1
	  ,V.ContactEmail2 as VisitContactEmail2
	  ,V.ContactEmail3 as VisitContactEmail3
      
FROM            tblFacility  F with(nolock)
left join tblFacilityOption O with(nolock) on F.FacilityID = O.facilityID
left join tblVisitFacilityConfig V with(nolock) on F.FacilityID = V.facilityID
Where F.FacilityID = @facilityID

