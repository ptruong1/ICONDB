CREATE PROCEDURE [dbo].[p_Report_Billed_Calls_Detail_SNo1]

@FromNo	varchar(10),
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime,  -- Required 
@divisionID	int
 AS


If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) > 0 
Begin
	If ( rtrim(@FromNo)	<> ''  and @FromNo is not null )
	    If @divisionID > 0
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock)
			, tblCommRateAgent with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							
			fromNo = @fromNo and 
			tblCallsBilled.facilityID = @divisionID and
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  tblcallsBilled.AgentID = @AgentID  
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
			else
			Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock)
			, tblCommrate with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
		  tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							
			fromNo = @fromNo and 
			tblCallsBilled.facilityID = @divisionID and
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  tblcallsBilled.AgentID = @AgentID  
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate

	   Else --
	   if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock), 
			 tblCommRateAgent with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			fromNo = @fromNo and 
			
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  tblcallsBilled.AgentID = @AgentID  and convert (int,duration ) >5  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
	else
	Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock), 
			 tblCommrate with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
		  tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
			fromNo = @fromNo and 
			
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  tblcallsBilled.AgentID = @AgentID  and convert (int,duration ) >5  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate

	Else --
	    If @divisionID > 0
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock)
			, tblCommRateAgent with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							  tblCallsBilled.facilityID = @divisionID and
							tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
			else
			Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock)
			, tblCommrate with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
		  tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							  tblCallsBilled.facilityID = @divisionID and
							tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate

			
	     else --
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock)
			, tblCommRateAgent with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
			else
			Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock)
			, tblCommrate with(nolock), tblBadDebt
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblcallsbilled.AgentID = tblCommrate.AgentID AND
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
							tblcallsbilled.Billtype =  tblCommrate.billtype and
							 tblcallsbilled.Calltype = tblCommrate.Calltype and
							tblcallsbilled.agentID = @agentID and
							 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
							  tblcallsbilled.billtype =  tblBadDebt.billtype and
							  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
							  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate

End 


else --
If (@AgentId >1 AND @facilityID =0 ) and (select count(*) from tblBadDebt with(nolock) where  AgentID = @AgentID ) = 0
---------------------------------
Begin
	If ( rtrim(@FromNo)	<> ''  and @FromNo is not null )
	    If @divisionID > 0
	    if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock), tblCommRateAgent  with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsBilled.AgentID =@AgentID  and 
			 tblcallsBilled.errorcode = '0' and 
			 tblcallsbilled.AgentID=  tblCommRateAgent.AgentID and
			 tblcallsbilled.Billtype = tblCommRateAgent.billtype and
			 tblcallsbilled.Calltype =tblCommRateAgent.Calltype and
			fromNo = @fromNo and 
			tblCallsBilled.facilityID = @divisionID and
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  tblcallsBilled.AgentID = @AgentID  
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
			else
			Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock), tblCommrate  with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsBilled.AgentID =@AgentID  and 
			 tblcallsBilled.errorcode = '0' and 
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.AgentID=  tblCommrate.AgentID and
			 tblcallsbilled.Billtype = tblCommrate.billtype and
			 tblcallsbilled.Calltype =tblCommrate.Calltype and
			fromNo = @fromNo and 
			tblCallsBilled.facilityID = @divisionID and
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  tblcallsBilled.AgentID = @AgentID  
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
	   Else --
	   if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsBilled.AgentID =@AgentID  and 
			 tblcallsBilled.errorcode = '0' and 
			 tblcallsbilled.AgentID=  tblCommRateAgent.AgentID and
			 tblcallsbilled.Billtype = tblCommRateAgent.billtype and
			 tblcallsbilled.Calltype =tblCommRateAgent.Calltype and
			fromNo = @fromNo and 
			
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and  convert (int,duration ) >5  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
			else
			Select  Location,  fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
			tblCallsBilled.facilityID = tblfacility.FacilityID and
			 tblcallsBilled.AgentID =@AgentID  and 
			 tblcallsBilled.errorcode = '0' and 
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.AgentID=  tblCommrate.AgentID and
			 tblcallsbilled.Billtype = tblCommrate.billtype and
			 tblcallsbilled.Calltype =tblCommrate.Calltype and
			fromNo = @fromNo and 
			
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )  and convert (int,duration ) >5  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
	Else
	      If @divisionID > 0
	      Begin
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
 
		Select  Location,  fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName   , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock), tblACPs with(nolock) , tblBilltype with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
			  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and 
				 tblcallsBilled.errorcode = '0' and 
				 tblcallsbilled.AgentID=  tblCommRateAgent.AgentID and
				 tblcallsbilled.Billtype = tblCommRateAgent.billtype and
				 tblcallsbilled.Calltype =tblCommRateAgent.Calltype and
				 tblcallsBilled.AgentID =@AgentID  and
				tblCallsBilled.facilityID = @divisionID and 
				tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
		else
			Select  Location,  fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName   , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock), tblACPs with(nolock) , tblBilltype with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
			  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and 
				 tblcallsBilled.errorcode = '0' and 
				tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
				 tblcallsbilled.AgentID=  tblCommrate.AgentID and
				 tblcallsbilled.Billtype = tblCommrate.billtype and
				 tblcallsbilled.Calltype =tblCommrate.Calltype and
				 tblcallsBilled.AgentID =@AgentID  and
				tblCallsBilled.facilityID = @divisionID and 
				tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
			end
	     else --- division = -1
	     Begin
	     if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
		Select  Location,  fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName   , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock), tblACPs with(nolock) , tblBilltype with(nolock), tblFacility with(nolock), tblcommrateAgent with(nolock)
			  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and 
				 tblcallsBilled.errorcode = '0' and 
 				 tblcallsbilled.AgentID=  tblCommRateAgent.AgentID and
				 tblcallsbilled.Billtype = tblCommRateAgent.billtype and
				 tblcallsbilled.Calltype =tblCommRateAgent.Calltype and
				 tblcallsBilled.AgentID =@AgentID  and 
				tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
		else
		Select  Location,  fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType, callRevenue
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName   , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock), tblACPs with(nolock) , tblBilltype with(nolock), tblFacility with(nolock), tblCommrate with(nolock)
			  where   tblcallsBilled.Billtype = tblBilltype.billtype and 
				tblCallsBilled.facilityID = tblfacility.FacilityID and 
				 tblcallsBilled.errorcode = '0' and 
				tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
 				 tblcallsbilled.AgentID=  tblCommrate.AgentID and
				 tblcallsbilled.Billtype = tblCommrate.billtype and
				 tblcallsbilled.Calltype =tblCommrate.Calltype and
				 tblcallsBilled.AgentID =@AgentID  and 
				tblcallsBilled.UserName = tblACPs.IPAddress  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) )   
				and convert (int,duration ) >5  
				and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by Location, fromNo, RecordDate
	End
End 


else --- Search by facility
Begin
	If ( rtrim(@FromNo)	<> ''  and @FromNo is not null )
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType , callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblCalltype with(nolock), tblCommrateAgent with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
			 tblcallsBilled.FacilityID = @FacilityID  and
			 tblcallsbilled.Calltype = tblCalltype.Abrev and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
			 tblcallsBilled.errorcode = '0' and 
			fromNo = @fromNo and 
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )   
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by fromNo, RecordDate
	else
		Select   fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType , callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblCalltype with(nolock), tblcommrate with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
			 tblcallsBilled.FacilityID = @FacilityID  and
			 tblcallsbilled.Calltype = tblCalltype.Abrev and
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
			 tblcallsBilled.errorcode = '0' and 
			fromNo = @fromNo and 
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )   
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by fromNo, RecordDate
	
	
	Else --
	if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
	Select   fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType , callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblCalltype with(nolock), tblCommrateAgent with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
			 tblcallsBilled.FacilityID = @FacilityID  and
			 tblcallsbilled.Calltype = tblCalltype.Abrev and
			tblcallsbilled.AgentID = tblCommrateAgent.AgentID AND
			 tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
			 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and 
			 tblcallsBilled.errorcode = '0' and 
			--fromNo = @fromNo and 
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )   
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by fromNo, RecordDate
	else
		Select   fromNo , toNo,   RecordDate as  ConnectDateTime  ,  tblcallsBilled.Calltype,  tblBilltype.Descript  as  BillType , callRevenue  
			,dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement) as Duration, tblACPs.ComputerName as HostName , Channel, FolderDate , RecordFile  
			from tblcallsBilled with(nolock),  tblACPs with(nolock), tblBilltype with(nolock), tblCalltype with(nolock), tblcommrate with(nolock)
		  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
			 tblcallsBilled.FacilityID = @FacilityID  and
			 tblcallsbilled.Calltype = tblCalltype.Abrev and
			tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
			 tblcallsbilled.Billtype =  tblCommrate.billtype and
			 tblcallsbilled.Calltype = tblCommrate.Calltype and 
			 tblcallsBilled.errorcode = '0' and 
			--fromNo = @fromNo and 
			tblcallsBilled.UserName = tblACPs.IPAddress  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) )   
			and convert (int,duration ) >5  
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			Order by fromNo, RecordDate

		   


End
