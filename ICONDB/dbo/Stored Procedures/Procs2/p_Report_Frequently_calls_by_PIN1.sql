

CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_PIN1]
@facilityID	int,
@PIN	varchar(12),
@fromDate	smalldatetime,
@todate	smalldatetime
 AS
 declare @InmateID varchar(12) = ''
 SET @PIN = isnull(@PIN,'')
 If (  @PIN <>'')
	select @InmateID = (InmateID) from tblInmate where FacilityId = @FacilityID and PIN = @PIN
IF (  @InmateID <>'') 
	
	Select    InmateID, PIN  
		,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,
		sum(CallRevenue ) As CallRevenue
		  from tblcallsBilled  with(nolock) , tblcommrate with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype
		   and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		   and convert (int,duration ) >5   
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			and tblCallsBilled.InmateID = @InmateID	
		   Group by  InmateID, PIN
		  
Else
begin
Select    InmateID, PIN  
		,  Count(InmateID) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as Duration,
		sum(CallRevenue ) As CallRevenue
		  from tblcallsBilled  with(nolock) , tblcommrate with(nolock)
		   where  tblcallsBilled.FacilityID = @FacilityID   And   tblcallsBilled.errorcode = '0' and
		   tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype
		   and  (RecordDate between @fromDate and dateadd(d,1,@todate) ) 
		   and convert (int,duration ) >5   
		   and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			
		   Group by  InmateID, PIN
		   Order by CallsCount desc
end
