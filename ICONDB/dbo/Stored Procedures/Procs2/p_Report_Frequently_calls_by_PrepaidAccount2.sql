CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_PrepaidAccount2]
@facilityID	int,
@phoneNo	varchar(10),
@fromDate	smalldatetime,
@todate	smalldatetime

 AS
SET @phoneNo = isnull(@phoneNo,'')
IF (  @phoneNo <>'') 	

	Select    PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,	sum(CallRevenue ) as CallRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsBilled.errorcode = '0' and  
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				tblcallsBilled.facilityID = @facilityID and  
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5  
				  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
					and PhoneNo = @PhoneNo
					
		  Group by  PhoneNo
		 Order by  callsCount desc
Else
			 
		 Select    PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,	sum(CallRevenue ) as CallRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsBilled.errorcode = '0' and  
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				tblcallsBilled.facilityID = @facilityID and  
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5  
				 
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 

		  Group by  PhoneNo
		 Order by  callsCount desc
