
CREATE PROCEDURE [dbo].[p_Chart_CallsBilled]
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
	If @ChartRequest = 'All'
		Select datepart(month, RecordDate ) as months, count(CallRevenue ) as CallsCount 	from tblcallsBilled WITH(NOLOCK) 
		where    
			-- AgentID = @AgentID and
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		Group by datepart(month, RecordDate )
			order by months
	Else	If @ChartRequest = 'Year'
		Select datepart(month, RecordDate ) as Months, count(CallRevenue ) as CallsCount 	from tblcallsBilled WITH(NOLOCK) 
		where 
			datepart(Year, RecordDate) =  @Year  and   
			-- AgentID = @AgentID and
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		Group by datepart(Month, RecordDate )
			order by Months
	Else	If @ChartRequest = 'Month'
		select CONVERT(CHAR(10),RecordDate,112) as days, count(CallRevenue) as CallCount	from tblcallsBilled WITH(NOLOCK) 
		where  
			datepart(Year, RecordDate) =  @Year  and    
			datepart(month, RecordDate) =  @Month  and
			tblcallsBilled.errorcode = '0' and
			--AgentID = @AgentID and
			 tblcallsBilled.FacilityID = @FacilityID
	
		Group by CONVERT(CHAR(10),RecordDate,112) 
			order by days
	Else	If @ChartRequest = 'Date'
		select CONVERT(CHAR(10),RecordDate,112) as days, count(CallRevenue) as CallCount	from tblcallsBilled   WITH(NOLOCK) 
		where 	
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			--AgentID = @AgentID and
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		group by CONVERT(CHAR(10),RecordDate,112)
			order by days
	else
		select  datepart(hour, RecordDate) as hours, count(CallRevenue) as CallCount	from tblcallsBilled   WITH(NOLOCK) 
		where 	
			CONVERT(CHAR(10),RecordDate,112) =  @day  and
			--AgentID = @AgentID and
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		group by  datepart(hour, RecordDate)
			order by hours

End
Else
Begin
	If @ChartRequest = 'All'
		Select datepart(month, RecordDate ) as months, count(CallRevenue ) as CallsCount 		from tblcallsBilled WITH(NOLOCK) 
		where    
			
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		Group by datepart(month, RecordDate )
			order by months
	Else	If @ChartRequest = 'Year'
		Select datepart(month, RecordDate ) as Months, count(CallRevenue ) as CallsCount  		from tblcallsBilled WITH(NOLOCK) 
		where 
			datepart(Year, RecordDate) =  @Year  and   
			
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		Group by datepart(Month, RecordDate )
			order by Months
	Else	If @ChartRequest = 'Month'
		select CONVERT(CHAR(10),RecordDate,112) as days, count(CallRevenue) as CallCount 		from tblcallsBilled WITH(NOLOCK) 
		where  
			datepart(Year, RecordDate) =  @Year  and    
			datepart(month, RecordDate) =  @Month  and
			tblcallsBilled.errorcode = '0' and
			
			 tblcallsBilled.FacilityID = @FacilityID
	
		Group by CONVERT(CHAR(10),RecordDate,112) 
			order by days
	Else	If @ChartRequest = 'Date'
		select CONVERT(CHAR(10),RecordDate,112) as days, count(CallRevenue) as CallCount		from tblcallsBilled   WITH(NOLOCK) 
		where 	
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		group by CONVERT(CHAR(10),RecordDate,112)
			order by days
	else
		select  datepart(hour, RecordDate) as hours, count(CallRevenue) as CallCount 		from tblcallsBilled   WITH(NOLOCK) 
		where 	
			CONVERT(CHAR(10),RecordDate,112) =  @day  and
			
			tblcallsBilled.errorcode = '0' and
			 tblcallsBilled.FacilityID = @FacilityID
	
		group by  datepart(hour, RecordDate)
			order by hours

End

