
CREATE PROCEDURE [dbo].[p_Chart_Calls_Billed_AvgDuration]
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
		CONVERT(CHAR(10),RecordDate,112) =  @day  and
		AgentID = @AgentID and
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)
		order by hours

End
Else
Begin
	
	Select datepart(hour, RecordDate) as hours, MIN(duration) AS MinDur, Max(duration) AS MaxDur, AVG(duration) as  AvgDur
	from tblcallsBilled  with(nolock)
	where 	
		CONVERT(CHAR(10),RecordDate,112) =  @day  and
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)
		order by hours

End

