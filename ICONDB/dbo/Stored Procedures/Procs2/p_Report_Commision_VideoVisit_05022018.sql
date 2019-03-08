
create PROCEDURE [dbo].[p_Report_Commision_VideoVisit_05022018]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime
AS


If( @AgentID >1  and @facilityID =0 ) 
Begin
 SELECT [ApmNo],[FacilityID],[InmateID],[InmateName], 1 as TotalCount,[ApmDate],[ApmTime],S.Descript,T.Descript as Type
      ,[LimitTime],[StationID],isnull([VisitDuration],0) as [VisitDuration] ,[locationID],[TotalCharge],[Relationship],R.CommRate
	  ,(V.totalCharge * isnull(R.CommRate,0)) as CommPaid
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
 SELECT [ApmNo],[FacilityID],[InmateID],[InmateName], 1 as TotalCount,[ApmDate],[ApmTime],S.Descript,T.Descript as Type
      ,[LimitTime],[StationID],isnull([VisitDuration],0) as [VisitDuration],[locationID],[TotalCharge],[Relationship],R.CommRate
	  ,(V.totalCharge * isnull(R.CommRate,0)) as CommPaid
  FROM [tblVisitEnduserSchedule] V 
  left join tblVisitRate R on V.facilityId = R.RateId and R.VisitType = V.VisitType
  inner join tblVisitType T on V.visitType = T.VisitTypeId
  inner join  tblVisitStatus S on V.Status = S.StatusId
  where facilityId = @facilityId 
  and V.visitType in (1, 2)
  and V.Status = 5
  and (V.ApmDate between @fromDate and dateadd(d,1,@toDate)) 

 end
