
CREATE PROCEDURE [dbo].[p_Report_Commision_VideoVisit_PDF]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime
AS


If( @AgentID >1  and @facilityID =0 ) -- Current not used
Begin
 select convert( varchar(10), V.apmDate, 101) as 'Visit Date', T.Descript as 'Visit type' , V.InmateId as 'Inmate Id' ,
		StationID as 'Station ID', EndUserId as 'Visitor Account', ApmTime AS 'Connect Time',
		 
		  [VisitDuration] as 'Duration',  [TotalCharge] as 'Visit Revenue',
		  Cast(R.CommRate * 100  as Numeric(12,4)) as 'Comm Rate',
		  CAST(( V.totalCharge    *isnull(R.CommRate,0))  as Numeric(12,4) ) as 'Comm Paid'
			--(V.totalCharge * isnull(R.CommRate,0))  as 'Comm Paid'
			FROM [tblVisitEnduserSchedule] V 
  left join tblVisitRate R on V.facilityId = R.RateId and R.VisitType = V.VisitType
  inner join tblVisitType T on V.visitType = T.VisitTypeId
  inner join  tblVisitStatus S on V.Status = S.StatusId
  where facilityId = @facilityId 
  and V.visitType in (1, 2)
  and V.Status = 5
  and (V.ApmDate between @fromDate and dateadd(d,1,@toDate)) 

End
Else

 Begin
 select convert( varchar(10), V.apmDate, 101) as 'Visit Date', T.Descript as 'Visit type' , V.InmateId as 'Inmate Id' ,
		StationID as 'Station ID', EndUserId as 'Visitor Account', ApmTime AS 'Connect Time',
		 
		  [VisitDuration] as 'Duration',  [TotalCharge] as 'Visit Revenue',
		  Cast(R.CommRate * 100  as Numeric(12,4)) as 'Comm Rate',
		  CAST(( V.totalCharge    *isnull(R.CommRate,0))  as Numeric(12,4) ) as 'Comm Paid'
			--(V.totalCharge * isnull(R.CommRate,0))  as 'Comm Paid'
			FROM [tblVisitEnduserSchedule] V 
  left join tblVisitRate R on V.facilityId = R.RateId and R.VisitType = V.VisitType
  inner join tblVisitType T on V.visitType = T.VisitTypeId
  inner join  tblVisitStatus S on V.Status = S.StatusId
  where facilityId = @facilityId 
  and V.visitType in (1, 2)
  and V.Status = 5
  and (V.ApmDate between @fromDate and dateadd(d,1,@toDate)) 

 end
