CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_PIN]
@facilityID	int,
@PIN	varchar(12),
@fromDate	smalldatetime,
@todate	smalldatetime

 AS
SET @PIN = isnull(@PIN,'')
IF (  @PIN <>'') 
	
	Select   PIN, sum(CallRevenue) CallRevenue, count(CallRevenue ) CallsCount,CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2))  as Duration
        		 from tblcallsBilled with(nolock)
		  where 	  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate   and 
		FacilityId= @facilityID and  
		PIN =@PIN
		 group by  PIN 
		 Order by callsCount desc

Else
	Select   PIN, sum(CallRevenue) CallRevenue, count(CallRevenue ) CallsCount,CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2))  as Duration
        		 from tblcallsBilled with(nolock)
		  where 	  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate   and 
		FacilityId= @facilityID 
		
		 group by  PIN 
		 Order by callsCount desc
