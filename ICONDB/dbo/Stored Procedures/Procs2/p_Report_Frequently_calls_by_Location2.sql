CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_Location2]
@facilityID          int,
@LocationID	int,
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS

If(@LocationID> 0 )
	

	select  tblFacilityLocation.Descript as Location,  count(CallRevenue ) CallsCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityLocation  with(nolock) , tblANIs  with(nolock), tblcommrate with(nolock) 

	where  tblFacilityLocation.LocationID=tblANIs.LocationID and	
		tblANIs.ANIno =	tblcallsbilled.FromNo and
		tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and		
		tblcallsBilled.errorcode = '0' and 
		tblcallsbilled.facilityID	= @facilityID  And
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
		and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		and tblFacilityLocation.LocationID =@LocationID
	group by  tblFacilityLocation.Descript
	Order by callsCount desc

Else
  
		
		select  tblFacilityLocation.Descript as Location,  count(CallRevenue ) CallsCount,sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration, sum(CallRevenue) CallRevenue
	from tblcallsbilled  with(nolock), tblFacilityLocation  with(nolock) , tblANIs  with(nolock), tblcommrate with(nolock) 

	where  tblFacilityLocation.LocationID=tblANIs.LocationID and	
		tblANIs.ANIno =	tblcallsbilled.FromNo and
		tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and		
		tblcallsBilled.errorcode = '0' and 
		tblcallsbilled.facilityID	= @facilityID  And
		(RecordDate between @fromDate and dateadd(d,1,@todate) ) and convert (int,duration ) >5   
		and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	group by  tblFacilityLocation.Descript
	Order by callsCount desc
