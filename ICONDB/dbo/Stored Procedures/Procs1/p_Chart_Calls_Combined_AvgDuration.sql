
CREATE PROCEDURE [dbo].[p_Chart_Calls_Combined_AvgDuration]
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
	
	Select datepart(hour, RecordDate) as hours, MIN(duration) AS MinDur, Max(duration) AS MaxDur, AVG(duration) as  AvgDur, 1 as RecordID	from tblcallsBilled with(nolock) 
	where 	
		(Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) =  @day  and
		--AgentID = @AgentID and
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)

	Union All

	Select datepart(hour, RecordDate) as hours, 10 AS MinDur, 120 AS MaxDur, 65 as  AvgDur, 2 as RecordID	from tblcallsUnBilled  with(nolock) 
	where 	
		(Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) =  @day  and
		--AgentID = @AgentID and
		
		FacilityID = @FacilityID
		
	group by  datepart(hour, RecordDate)
		order by hours

End
Else
Begin
	
	Select datepart(hour, RecordDate) as hours, MIN(duration) AS MinDur, Max(duration) AS MaxDur, AVG(duration) as  AvgDur, 1 as RecordID	from tblcallsBilled   with(nolock)
	where 	
		(Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) =  @day  and
		
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)

	Union All

	Select datepart(hour, RecordDate) as hours, 10  AS MinDur,120  AS MaxDur, 65 as  AvgDur, 2 as RecordID	from tblcallsUnBilled  
	where 	
		(Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) =  @day  and
		
		 FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)
		order by hours


End

