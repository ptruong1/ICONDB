CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_DebitAccount2]
@facilityID	int,
@AccountNo	varchar(10),
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS
SET @AccountNo = isnull(@AccountNo,'')
IF(@AccountNo <>'')
	
	Select   Billtono as AccountNo , sum(CallRevenue) CallRevenue, count(CallRevenue ) CallsCount,CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2))  as Duration
        		 from tblcallsBilled with(nolock)
		  where 	  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate   and 
		FacilityId= @facilityID and  
		billtype ='07' and
		billtono =@AccountNo
		 group by billtono 
		 Order by callsCount desc
Else
	Select   Billtono as AccountNo , sum(CallRevenue) CallRevenue, count(CallRevenue ) CallsCount,CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2))  as Duration
        		 from tblcallsBilled with(nolock)
		  where 	  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate   and 
		FacilityId= @facilityID and  
		billtype ='07' 
		
		 group by billtono 
		 Order by callsCount desc
