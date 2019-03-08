CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_ANI2]
@facilityID	int,
@FromNo	varchar(10),
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS
SET @FromNo = isnull(@FromNo,'')
If( @FromNo <>'' )
	Select    FromNo,  Count( FromNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,
		sum(CallRevenue ) As CallRevenue
		  from tblcallsBilled  with(nolock), tblANIs with(nolock), tblcommrate with(nolock)
		   where fromNo = ANIno and  tblcallsBilled.FacilityID = @FacilityID  
		   And  tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			and FromNo = @FromNo
		   Group by  FromNo Order by callsCount desc


Else
       	
		 
		 Begin
	Select    FromNo,  Count( FromNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,
		sum(CallRevenue ) As CallRevenue
		  from tblcallsBilled  with(nolock), tblANIs with(nolock), tblcommrate with(nolock)
		   where fromNo = ANIno and  tblcallsBilled.FacilityID = @FacilityID  
		   And  tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		   Group by  FromNo Order by callsCount desc
end
