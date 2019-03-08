CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_tono2]
@facilityID	int,
@toNo	varchar(10),
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS
SET @toNo = isnull(@toNo,'')
IF ( @toNo <>'')
	Select    toNo, 
		Count( toNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,
		sum(CallRevenue ) As CallRevenue
		  from tblcallsBilled  with(nolock), tblcommrate with(nolock)
		   where   tblcallsBilled.FacilityID = @FacilityID  
		   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
		   (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		   and convert (int,duration ) >5
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)  
		  and ToNo = @toNo
		   Group by toNo Order by callsCount desc

Else
	
	Select    toNo, 
		Count( toNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,
		sum(CallRevenue ) As CallRevenue
		  from tblcallsBilled  with(nolock), tblcommrate with(nolock)
		   where   tblcallsBilled.FacilityID = @FacilityID  
		   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and
		   (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		   and convert (int,duration ) >5
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)  
		  
		   Group by toNo Order by callsCount desc
