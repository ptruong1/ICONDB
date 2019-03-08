
CREATE PROCEDURE [dbo].[p_select_facilities_detail]
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
      ,F.Status
      ,isnull(F.AcctExeID,1)as AcctExeID
      ,E.AcctExeName 
      ,E.BusPhone as AcctExeBusPhone
      ,E.CellPhone as AcctExeCellPhone
      ,E.Email as AcctExeEmail
      ,isnull(F.AcctRepID,1)as AcctRepID
      ,R.AcctRepName 
      ,R.BusPhone as AcctRepBusPhone
      ,R.CellPhone as AcctRepCellPhone
      ,R.Email as AcctRepEmail
      
FROM            tblFacility  F with(nolock)
left join tblFacilityOption O with(nolock) on F.FacilityID = O.facilityID
left join tblAccountExecutive E with (nolock) on isnull(F.AcctExeID,15) = E.AcctExeID
left join tblAccountRepresentative R with (nolock) on isnull(F.AcctRepID,15) = R.AcctRepID
Where F.FacilityID = @facilityID

