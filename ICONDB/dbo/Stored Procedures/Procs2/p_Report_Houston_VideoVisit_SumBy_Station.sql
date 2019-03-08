CREATE PROCEDURE [dbo].[p_Report_Houston_VideoVisit_SumBy_Station] 
(
	@facilityID	int,
	@fromDate	smalldatetime,
	@todate	smalldatetime
)
AS
	SET NOCOUNT ON;
	
	Select
        X.FacilityID
       ,X.Location
       ,X.Address
       ,X.Zipcode
       ,X.State
       ,X.Descript 
       ,X.StationID
       ,X.LocationName
       ,SUM(visitCount) VisitCount
       ,SUM(visitCount)  TVisitCount
       ,Sum(X.LimitTime)  TLimitTime
       ,Sum(X.VisitDuration)  TVisitDuration
       ,sum(X.CallRevenue) TCallRevenue
       ,sum(X.CommPaid)  TCommPaid  
  From
  
       (SELECT 
       V.FacilityID
       ,F.Location
       ,F.Address
       ,F.Zipcode
       ,F.State
       ,T.Descript
       ,V.StationID
       ,L.LocationName
       ,1 as visitCount
       ,V.ApmDate
       ,V.ApmTime
       ,(V.LimitTime) as LimitTime
       ,(V.VisitDuration) VisitDuration
       ,(V.TotalCharge) as CallRevenue
       ,'65.00' as CommRate
       ,(cast(Cast((V.TotalCharge * .65) as float) as Numeric(12,2)))  CommPaid
       ,'2' recordCode
       ,NULL  TVisitCount
       ,NULL  TLimitTime
       ,NULL  TVisitDuration
       ,NULL  TCallRevenue
       ,NULL  TCommPaid
           
  FROM [leg_Icon].[dbo].[tblVisitEnduserSchedule] V 
  left join [leg_Icon].[dbo].[tblfacility] F on v.facilityID = F.facilityID
  left join [leg_Icon].[dbo].[tblVisitLocation] L on v.locationID = L.LocationID
  left join [leg_Icon].[dbo].[tblVisitType] T on V.visitType = T.VisitTypeID
  where V.FacilityID = @facilityID and
  (V.apmDate between @fromDate and dateadd(d,0,@toDate) )
  and V.status = 5 ) as X
  group by X.facilityId,
		X.Location
       , X.Address
       ,X.Zipcode
       ,X.State
       ,X.Descript
       ,X.StationID
       ,X.LocationName 
