
CREATE PROCEDURE [dbo].[p_Report_billed_calls_Sum_by_PrepaidAccount2]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@divisionID	int


 AS

If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0 

Begin
        If @divisionID > 0
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and
			   tblcallsBilled.errorcode = '0' and   
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  '10' and
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblCallsBilled.facilityID = @divisionID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 
				
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
		 else
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and
			   tblcallsBilled.errorcode = '0' and  
			   tblcallsbilled.Billtype =  '10' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				tblCallsBilled.facilityID = @divisionID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 
				
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
        Else---
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommRateAgent with(nolock), tblBaddebt with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and  
			   tblcallsbilled.Billtype =  '10' and
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
		 else
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock), tblBaddebt with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and  
			   tblcallsbilled.Billtype =  '10' and
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
				  tblcallsbilled.billtype =  tblBadDebt.billtype and
				  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
				  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
 End
else--
-------
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID )  = 0
Begin
        If @divisionID > 0
        if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblcommrateAgent with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and
			   tblcallsBilled.errorcode = '0' and   
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  '10' and
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 
				
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
		else
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and
			   tblcallsBilled.errorcode = '0' and  
			   tblcallsbilled.Billtype =  '10' and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				tblCallsBilled.facilityID = @divisionID and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
				 
				
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
        Else--
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblcommrateAgent with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and  
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				tblcallsbilled.Billtype =  '10' and
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
		 else
		Select    Location, PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) , tblFacility with(nolock)
			  , tblCommrate with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and 
			   tblcallsBilled.errorcode = '0' and  
			   tblcallsbilled.Billtype =  '10' and
				tblCallsBilled.facilityID = tblfacility.FacilityID and
				tblcallsbilled.AgentID = tblCommrate.AgentID AND
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblPrepaid.FacilityID = tblCallsBilled.FacilityID and
				tblPrepaid.PhoneNo = tblcallsBilled.billtono   and
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				   convert (int,duration ) >5  
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
		Group by  Location, PhoneNo
		 Order by  Location, PhoneNo
 End
else--
Begin
if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
Select    PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,	sum(CallRevenue ) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock), tblCommrateAgent with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsBilled.errorcode = '0' and 
			   tblcallsbilled.Billtype =  '10' and 
				tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
				 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
				 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
				 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				tblcallsBilled.facilityID = @facilityID and  
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5  
				 
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 

		  Group by  PhoneNo
		 Order by  PhoneNo
else
 Select    PhoneNo as [Account No],  Count(  PhoneNo) as CallsCount, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes,	sum(CallRevenue ) as TotalRevenue
			  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock), tblcommrate with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and
			   tblcallsBilled.errorcode = '0' and
			   tblcallsbilled.Billtype =  '10' and  
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
				 tblcallsbilled.Billtype =  tblCommrate.billtype and
				 tblcallsbilled.Calltype = tblCommrate.Calltype and
				 tblPrepaid.FacilityID =  tblcallsBilled.FacilityID  And
				tblcallsBilled.facilityID = @facilityID and  
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >5  
				 
				 and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 

		  Group by  PhoneNo
		 Order by  PhoneNo
 End
