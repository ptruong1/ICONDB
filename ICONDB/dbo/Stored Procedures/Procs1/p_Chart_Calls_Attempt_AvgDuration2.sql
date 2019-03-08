
CREATE PROCEDURE [dbo].[p_Chart_Calls_Attempt_AvgDuration2]
@FacilityID  int ,
@AgentID   int,
@ChartRequest varchar(10),
@Year int,
@month int,
@day varchar(11),
@fromDate smalldatetime,
@toDate smalldatetime
 AS
If( @AgentID > 0 )
Begin
	
	Select datepart(hour, RecordDate) as hours, MIN(duration) AS MinDur, Max(duration) AS MaxDur, AVG(duration) as  AvgDur
	from tblcallsBilled  with(nolock)
	where 	
		(Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) =  @day  and
		--AgentID = @AgentID and
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)
		order by hours

End
Else
Begin
	
	Select datepart(hour, RecordDate) as hours, MIN(duration) AS MinDur, Max(duration) AS MaxDur, AVG(duration) as  AvgDur
	from tblcallsBilled with(nolock)
	where 	
		(Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) =  @day  and
		
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)
		order by hours

End

