
CREATE PROCEDURE [dbo].[p_Chart_CallsUnBilled2]
@FacilityID  int ,
@AgentID   int,
@ChartRequest varchar(10),
@Year int,
@month int,
@day varchar(11),
@fromDate smalldatetime,
@toDate smalldatetime
 AS

Begin
	If @ChartRequest = 'All'
		Select datepart(month, RecordDate ) as months, count(CallTime ) as CallsCount 		from tblcallsUnbilled  WITH(NOLOCK) 
		where    
			
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		Group by datepart(month, RecordDate )
			order by months
	Else	If @ChartRequest = 'Year'
		Select datepart(month, RecordDate ) as Months, count(CallTime ) as CallsCount 		from tblcallsUnbilled WITH(NOLOCK) 
		where 
			datepart(Year, RecordDate) =  @Year  and   
			
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		Group by datepart(Month, RecordDate )
			order by Months
	Else	If @ChartRequest = 'Month'
		Select (Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2))   as days, count(CallTime ) as CallsCount 		from tblcallsUnbilled WITH(NOLOCK) 
		where  
			datepart(Year, RecordDate) =  @Year  and    
			datepart(month, RecordDate) =  @Month  and
			
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		Group by (Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2))
			order by days
	Else	If @ChartRequest = 'Date'
		select (Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) as days, count(CallTime) as CallCount	from tblcallsUnbilled   WITH(NOLOCK) 
		where 	
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		group by   (Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2))
			order by days
	else
		select  datepart(hour, RecordDate) as hours, count(CallTime) as CallCount		from tblcallsUnbilled   WITH(NOLOCK) 
		where 	
			(Substring(CallDate, 3, 2) + '/' + Substring(CallDate, 5, 2) + '/' + Substring(CallDate, 1, 2)) =  @day  and
			
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		group by  datepart(hour, RecordDate)
			order by hours

End

