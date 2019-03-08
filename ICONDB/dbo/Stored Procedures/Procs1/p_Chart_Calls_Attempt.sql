
CREATE PROCEDURE [dbo].[p_Chart_Calls_Attempt]
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
	 If @ChartRequest = 'Year'
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
		order by Months

	else  If @ChartRequest = 'Month'
		select CONVERT(CHAR(10),X.RecordDate,112) as days, count(X.RecordDate) as CallCount	from 
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

			order by days

	Else If @ChartRequest = 'Date'
		select CONVERT(CHAR(10),X.RecordDate,112) as days, count(X.RecordDate) as CallCount	from 

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
			order by days
	else
		select  datepart(hour, X.RecordDate) as hours, count( X.RecordDate) as CallCount	from 
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
			order by hours

End
Else
Begin
	 If @ChartRequest = 'Year'
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
		order by Months

	else  If @ChartRequest = 'Month'
		select CONVERT(CHAR(10),X.RecordDate,112) as days, count(X.RecordDate) as CallCount	from 
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

			order by days

	Else If @ChartRequest = 'Date'
		select CONVERT(CHAR(10),X.RecordDate,112) as days, count(X.RecordDate) as CallCount	from 

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
			order by days
	else
		select  datepart(hour, X.RecordDate) as hours, count( X.RecordDate) as CallCount	from 
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
			order by hours

End

