CREATE PROCEDURE [dbo].[p_Report_Houston_VideoVisit_By_Station] 
(
	@facilityID	int,
	@fromDate	smalldatetime,
	@todate	smalldatetime
)
AS
	SET NOCOUNT ON;
	
	Select
        T.FacilityID
       ,T.Location
       ,T.Address
       ,T.Zipcode
       ,T.State
       ,T.StationID
       ,T.LocationName
       ,T.Descript
       --,T.VisitCount
       ,T.ApmDate
       ,T.ApmTime
       --,T.LimitTime
       ,T.VisitDuration
       ,T.CallRevenue
       ,T.CommRate
       ,T.CommPaid
       --,T.recordCode
       ,T.TVisitCount as TotalVisits
       --,T.TLimitTime
       ,T.TVisitDuration as ToTalTime
       ,T.TCallRevenue as TotalRevenue
       ,T.TCommPaid as TotalComm
 from
(SELECT 
       V.FacilityID
       ,F.Location
       ,F.Address
       ,F.Zipcode
       ,F.State
       ,V.StationID
       ,L.LocationName
       ,T.Descript
       ,1 as visitCount
       ,V.ApmDate
       ,V.ApmTime
       ,(V.LimitTime) as LimitTime
       ,(V.VisitDuration) VisitDuration
       ,'65.00' as CommRate
       ,(V.TotalCharge) as CallRevenue
       ,(cast(Cast((V.TotalCharge * .65) as float) as Numeric(12,2)))  CommPaid
       ,'1' as recordCode
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
  and V.status = 5 
  
  Union all
  
  Select
        X.FacilityID
       ,X.Location
       ,X.Address
       ,X.Zipcode
       ,X.State
       ,X.StationID
       ,X.LocationName
       ,X.Descript
       ,SUM(visitCount) VisitCount
       ,NULL as ApmDate
       ,NULL as ApmTime
       ,NULL as LimitTime
       ,NULL VisitDuration
       ,NULL as CallRevenue
       ,NULL as CommRate
       ,NULL  CommPaid
       ,'2' recordCode
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
       ,V.StationID
       ,L.LocationName
       ,T.Descript
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
  and V.status = 99 ) as X
  group by X.facilityId,
		X.Location
       , X.Address
       ,X.Zipcode
       ,X.State
       ,X.StationID
       ,X.LocationName
       ,X.descript )
       
       as T
       
    order by T.facilityId,
		T.Location
       , T.Address
       ,T.Zipcode
       ,T.State
       ,T.StationID
       ,T.LocationName
       ,T.Descript
       ,T.recordCode
