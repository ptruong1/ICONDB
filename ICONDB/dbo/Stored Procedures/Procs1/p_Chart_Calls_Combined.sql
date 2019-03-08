
CREATE PROCEDURE [dbo].[p_Chart_Calls_Combined]
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
Begin If @ChartRequest = 'Year'
	Select datepart(month, X.RecordDate ) as Months, count(X.RecordDate) as CallsCount, 1 as CallPeriod from 
	 (Select RecordDate from tblcallsBilled WITH(NOLOCK) 
	where 
		datepart(Year, RecordDate) =  @Year  and   
		-- AgentID = @AgentID and
		 tblcallsBilled.FacilityID = @FacilityID
	Union all
		Select RecordDate   
	 	from tblcallsUnbilled  WITH(NOLOCK) 
	where 
		datepart(Year, RecordDate) =  @Year  and   
		-- AgentID = @AgentID and
		 tblcallsUnBilled.FacilityID = @FacilityID
	) as X
	Group by datepart(Month,X.RecordDate )

	Union All

	Select datepart(month, RecordDate ) as Months, count(CallRevenue ) as CallsCount, 2 as CallPeriod 	from tblcallsBilled with(nolock)
	where 
		datepart(Year, RecordDate) =  @Year  and   
		-- AgentID = @AgentID and
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID 

	Group by datepart(Month, RecordDate )

	Union All

	Select datepart(month, RecordDate ) as Months, count(CallTime ) as CallsCount, 3 as CallPeriod 	from tblcallsUnbilled with(nolock)
	where 
		datepart(Year, RecordDate) =  @Year  and   
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	Group by datepart(Month, RecordDate )
		order by Months, CallPeriod
		
Else If @ChartRequest = 'Month'
	select CONVERT(CHAR(10),X.RecordDate,112) as days, count(X.RecordDate) as CallCount, 1 as CallPeriod from
		 
      		 (Select RecordDate from tblcallsBilled WITH(NOLOCK) 
		where  
			datepart(Year, RecordDate) = @year  and    
			datepart(month, RecordDate) = @Month and
			tblcallsBilled.errorcode = '0' and
			--AgentID = @AgentID and
			 tblcallsBilled.FacilityID = @FacilityID
				
		Union all
		Select RecordDate   
	 	from tblcallsUnbilled  WITH(NOLOCK) 
		where  
			datepart(Year, RecordDate) = @year  and    
			datepart(month, RecordDate) = @Month and
			--tblcallsUnbilled.errortype > '0' and
			 tblcallsUnbilled.FacilityID = @FacilityID
		) as X
	
		Group by CONVERT(CHAR(10),X.RecordDate,112)

			
		
	Union All

	select CONVERT(CHAR(10),RecordDate,112) as days, count(RecordDate) as CallCount, 	2 as CallPeriod from tblcallsBilled with(nolock)
	where  
		datepart(Year, RecordDate) =  @Year  and    
		datepart(month, RecordDate) =   @month and
		tblcallsBilled.errorcode = '0' and
		--AgentID = @AgentID and
		 tblcallsBilled.FacilityID = @FacilityID
	Group by CONVERT(CHAR(10),RecordDate,112)
		
	Union All

	Select CONVERT(CHAR(10),RecordDate,112)   as days, count(CallTime ) as CallsCount,	3 as CallPeriod from tblcallsUnbilled with(nolock)
	where  
		datepart(Year, RecordDate) =  @Year  and    
		datepart(month, RecordDate) =  @month and
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	Group by CONVERT(CHAR(10),RecordDate,112)
	order by days, CallPeriod

Else If @ChartRequest = 'Date'

	select CONVERT(CHAR(10),X.RecordDate,112) as days, count(X.RecordDate) as CallCount, 1 as CallPeriod	from 

      		 (Select RecordDate from tblcallsBilled WITH(NOLOCK) 
		where 	
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			--AgentID = @AgentID and
			 tblcallsBilled.FacilityID = @FacilityID
		Union all
		Select RecordDate   
	 	from tblcallsUnbilled  WITH(NOLOCK) 
		where  
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
			--AgentID = @AgentID and
			 tblcallsUnbilled.FacilityID = @FacilityID
		) as X
	
		Group by CONVERT(CHAR(10),X.RecordDate,112)
			
	Union All

	select CONVERT(CHAR(10),RecordDate,112) as days, count(CallRevenue) as CallCount, 2 as CallPeriod	from tblcallsBilled  with(nolock)
	where 	
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
		--AgentID = @AgentID and
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID

	group by CONVERT(CHAR(10),RecordDate,112)
	
	
	Union All

	select CONVERT(CHAR(10),RecordDate,112) as days, count(CallTime) as CallCount, 3 as Callperiod	from tblcallsUnbilled with(nolock) 
	where 	
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	group by   CONVERT(CHAR(10),RecordDate,112)
		order by days, CallPeriod


else
	select  datepart(hour, X.RecordDate) as hours, count( X.RecordDate) as CallCount, 1 as CallPeriod	from 
		 (Select RecordDate from tblcallsBilled WITH(NOLOCK) 
		where 	
			 CONVERT(CHAR(10),RecordDate,112)  =  @day  and
			--AgentID = @AgentID and
			 tblcallsBilled.FacilityID = @FacilityID
		Union All
		Select RecordDate from tblcallsUnBilled WITH(NOLOCK)
		where 	
			 CONVERT(CHAR(10),RecordDate,112)  =  @day  and
			--AgentID = @AgentID and
			 tblcallsUnbilled.FacilityID = @FacilityID
		) as X
		group by  datepart(hour, X.RecordDate)
			

	Union All

	select  datepart(hour, RecordDate) as hours, count(CallRevenue) as CallCount, 2 as CallPeriod	from tblcallsBilled  with(nolock)
	where 	
		CONVERT(CHAR(10),RecordDate,112) =  @day  and
		--AgentID = @AgentID and
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)

	Union All
		
	select  datepart(hour, RecordDate) as hours, count(CallTime) as CallCount, 3 as CallPeriod	from tblcallsUnbilled  with(nolock)
	where 	
		CONVERT(CHAR(10),RecordDate,112) =  @day  and
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)
		order by hours, CallPeriod
		
End
Else 
Begin 
If @ChartRequest = 'Year'
	Select datepart(month, RecordDate ) as Months, count(fromNo) as CallsCount, 1 as CallPeriod	from tblCallAttempt with(nolock)
	where 
		datepart(Year, RecordDate) =  @Year  and   
		
		 tblCallAttempt.FacilityID = @FacilityID

	Group by datepart(Month, RecordDate )

	Union All

	Select datepart(month, RecordDate ) as Months, count(CallRevenue ) as CallsCount, 2 as CallPeriod	from tblcallsBilled with(nolock)
	where 
		datepart(Year, RecordDate) =  @Year  and   
		
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID

	Group by datepart(Month, RecordDate )

	Union All

	Select datepart(month, RecordDate ) as Months, count(CallTime ) as CallsCount, 3 as CallPeriod	from tblcallsUnbilled with(nolock)
	where 
		datepart(Year, RecordDate) =  @Year  and   
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	Group by datepart(Month, RecordDate )
		order by Months, CallPeriod
		
Else If @ChartRequest = 'Month'
	select CONVERT(CHAR(10),RecordDate,112) as days, count(fromNo) as CallCount, 	1 as CallPeriod from tblCallAttempt with(nolock)
	where  
		datepart(Year, RecordDate) =  @Year  and    
		datepart(month, RecordDate) =  @month  and
		
		 tblCallAttempt.FacilityID = @FacilityID

	Group by CONVERT(CHAR(10),RecordDate,112)
		
	Union All

	select CONVERT(CHAR(10),RecordDate,112) as days, count(CallRevenue) as CallCount,	2 as CallPeriod from tblcallsBilled with(nolock)
	where  
		datepart(Year, RecordDate) =  @Year  and    
		datepart(month, RecordDate) =   @month and
		tblcallsBilled.errorcode = '0' and
		
		 tblcallsBilled.FacilityID = @FacilityID

	Group by CONVERT(CHAR(10),RecordDate,112)
		
	Union All

	Select CONVERT(CHAR(10),RecordDate,112)   as days, count(CallTime ) as CallsCount,	3 as CallPeriod from tblcallsUnbilled with(nolock)
	where  
		datepart(Year, RecordDate) =  @Year  and    
		datepart(month, RecordDate) =  @month and
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	Group by CONVERT(CHAR(10),RecordDate,112)
		order by days, CallPeriod

Else If @ChartRequest = 'Date'

	select  CONVERT(CHAR(10),RecordDate,112) as days, count(fromNo) as CallCount, 1 as CallPeriod	from tblCallAttempt  with(nolock)
	where 	
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
		AgentID = @AgentID and
		 tblCallAttempt.FacilityID = @FacilityID

	group by CONVERT(CHAR(10),RecordDate,112)

	Union All

	select CONVERT(CHAR(10),RecordDate,112) as days, count(CallRevenue) as CallCount, 2 as CallPeriod	from tblcallsBilled  with(nolock)
	where 	
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
		AgentID = @AgentID and
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID

	group by CONVERT(CHAR(10),RecordDate,112)
	
	
	Union All

	select CONVERT(CHAR(10),RecordDate,112) as days, count(CallTime) as CallCount, 3 as Callperiod	from tblcallsUnbilled with(nolock) 
	where 	
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	group by   CONVERT(CHAR(10),RecordDate,112)
		order by days, CallPeriod

else

	select  datepart(hour, RecordDate) as hours, count(fromNo) as CallCount, 1 as CallPeriod	from tblCallAttempt  with(nolock)
	where 	
		 CONVERT(CHAR(10),RecordDate,112)  =  @day  and
		
		 tblCallAttempt.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)

	Union All

	select  datepart(hour, RecordDate) as hours, count(CallRevenue) as CallCount, 2 as CallPeriod	from tblcallsBilled  with(nolock)
	where 	
		CONVERT(CHAR(10),RecordDate,112) =  @day  and
		
		tblcallsBilled.errorcode = '0' and
		 tblcallsBilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)

	Union All
		
	select  datepart(hour, RecordDate) as hours, count(CallTime) as CallCount, 3 as CallPeriod	from tblcallsUnbilled  with(nolock)
	where 	
		CONVERT(CHAR(10),RecordDate,112) =  @day  and
		
		 tblcallsUnbilled.FacilityID = @FacilityID

	group by  datepart(hour, RecordDate)
		order by hours, CallPeriod
		
End

