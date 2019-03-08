
CREATE PROCEDURE [dbo].[p_Chart_CallsUnBilled]
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
		Select datepart(month, RecordDate ) as months, count(CallTime ) as CallsCount 		from tblcallsUnbilled WITH(NOLOCK) 
		where    
			--tblcallsUnbilled.errortype > '0' and
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		Group by datepart(month, RecordDate )
			order by months
	Else
	If @ChartRequest = 'Year'
		Select datepart(month, RecordDate ) as Months, count(CallTime ) as CallsCount 		from tblcallsUnbilled WITH(NOLOCK) 
		where 
			datepart(Year, RecordDate) =  @Year  and   
			--tblcallsUnbilled.errortype > '0' and
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		Group by datepart(Month, RecordDate )
			order by Months
	Else	If @ChartRequest = 'Month'
		Select CONVERT(CHAR(10),RecordDate,112)   as days, count(CallTime ) as CallsCount 	from tblcallsUnbilled  WITH(NOLOCK) 
		where  
			datepart(Year, RecordDate) =  @Year  and    
			datepart(month, RecordDate) =  @Month  and
			--tblcallsUnbilled.errortype > '0' and
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		Group by CONVERT(CHAR(10),RecordDate,112)
			order by days
	Else	If @ChartRequest = 'Date'
		select CONVERT(CHAR(10),RecordDate,112) as days, count(CallTime) as CallCount		from tblcallsUnbilled  WITH(NOLOCK) 
		where 	
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			--tblcallsUnbilled.errortype > '0' and
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		group by   CONVERT(CHAR(10),RecordDate,112)
			order by days
	else
		select  datepart(hour, RecordDate) as hours, count(CallTime) as CallCount		from tblcallsUnbilled   WITH(NOLOCK) 
		where 	
			CONVERT(CHAR(10),RecordDate,112) =  @day  and
			--tblcallsUnbilled.errortype > '0' and
			 tblcallsUnbilled.FacilityID = @FacilityID
	
		group by  datepart(hour, RecordDate)
			order by hours

End

