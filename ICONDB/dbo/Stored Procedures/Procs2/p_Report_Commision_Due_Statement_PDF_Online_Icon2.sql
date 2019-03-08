Create  PROCEDURE [dbo].[p_Report_Commision_Due_Statement_PDF_Online_Icon2]
@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@DivisionID	int
AS



 Begin
 	select 
	 X.Bill as "Bill Type" 
	, X.Call as "Call Type"
	, sum(X.callcount) as "Call Count" 
	,sum(X.duration)  as CallDuration 
	,sum(X.CallRevenue) as "Call Revenue"
	,X.CommRate   as "Comm Rate" 
	,(sum(X.commpaid))   as "Comm Paid"
	
	from
	(select Calldate, tblbilltype.Descript as Bill , tblCallType.Descript as call, 1 as callcount,
	fromno ,tono , 
		dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement ) as duration,  CallRevenue,  
		Cast(tblCommrate.CommRate * 100  as Numeric(12,4)) as commrate ,
		CAST (((CallRevenue)   * tblCommrate.CommRate) as Numeric(7,2)) as commpaid
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						
						(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
	) X
	group by  X.Bill, X.Call,x.CommRate
	Order by  X.Bill, X.Call,x.CommRate

	End