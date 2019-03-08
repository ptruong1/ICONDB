CREATE PROCEDURE [dbo].[p_Report_Commision_Summary_by_DebitNo2_test]

@facilityID	int,
@AgentID	int,
@fromDate	smalldatetime,
@todate	smalldatetime,
@AccountNo	varchar(12),
@divisionID	int
AS
if (@AccountNo='')
Begin
If(@AgentID	>1 AND @facilityID =0 )
 	Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
	   if @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select   tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
		else
			Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select  tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1  as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock), tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrate.AgentID and
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								  tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			Select AccountNo,  Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock),  tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
		else
			Select AccountNo,  Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock),   tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrate.AgentID and
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
							                tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and						
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
				
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
			Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock) , tblDebit with(nolock)
			WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID =  @divisionID and
							tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo

		Else
		Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
		(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  , tblDebit with(nolock)
			WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.agentID = @agentID and
							tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
		
 	end	
Else
 	
	Select AccountNo, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
	(select tblDebit.AccountNo as AccountNo, Calldate,  fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate,  1 as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,0  Pif, 0  BadDebtRate,  
		0 as BadDebt, (tblCommrate.CommRate * 100) as CommRate,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)     End)  as CommPaid
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock) , tblDebit with(nolock)
		WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						--tblcallsbilled.agentID = @agentID and
						tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by  AccountNo
			Order by  AccountNo
End
Else   -- AccountNo <> ''
Begin
If(@AgentID	>1 AND @facilityID =0 )
 	Begin
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) > 0
	   if @divisionID > 0
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock) , tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								tblcallsBilled.CreditcardNo	= @AccountNo and 
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
		else
			Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select  tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1  as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock) , tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrate.AgentID and
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
								  tblcallsbilled.FacilityID =  tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								tblcallsbilled.FacilityID =  @divisionID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								tblcallsBilled.CreditcardNo	= @AccountNo and 
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
		
	      else	
		if(select count(*) from tblCommRateAgent with(nolock) where AgentID= @AgentID) > 0
			Select AccountNo,  Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select  tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock) , tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
								tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
								 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								tblcallsBilled.CreditcardNo	= @AccountNo and 
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
		else
			Select AccountNo,  Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount,  dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif,  (isnull(Rate,0)*100) BadDebtRate,  
				CAST((CallRevenue * Rate)  as Numeric(12,4)) as BadDebt, (tblCommrate.CommRate * 100) as CommRate, 
				(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
				 Else CAST((( CallRevenue - (CallRevenue * isnull(Rate,0) ) - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrate.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
				from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock), tblBadDebt with(nolock) ,  tblFacility with(nolock) , tblDebit with(nolock)
				WHERE
								tblcallsbilled.Billtype = tblBilltype.Billtype and
								 tblcallsBilled.errorcode = '0' and 
								tblcallsbilled.Calltype = tblCalltype.Abrev and
								tblcallsbilled.AgentID=  tblCommrate.AgentID and
								tblcallsbilled.Billtype =  tblCommrate.billtype and
								 tblcallsbilled.Calltype = tblCommrate.Calltype and
							                tblcallsbilled.FacilityID = tblCommrate.FacilityID and
								 tblcallsbilled.FacilityID = tblBadDebt.FacilityID and						
								  tblcallsbilled.billtype =  tblBadDebt.billtype and
								  tblcallsbilled.Calltype =  tblBadDebt.Calltype and
								  tblcallsbilled.AgentID =  tblBadDebt.AgentID and
								tblcallsbilled.FacilityID =  tblFacility.FacilityID and
								 tblcallsbilled.agentID = @agentID and
								tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								tblcallsBilled.CreditcardNo	= @AccountNo and 
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo
	
	else
	If (select count(*) from tblBadDebt  with(nolock) where AgentID = @AgentID) = 0
	    
		If @divisionID > 0
			Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
			(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)   , tblDebit with(nolock)
			WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							tblcallsbilled.agentID = @agentID and
							tblcallsbilled.FacilityID =  @divisionID and
							tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								tblcallsBilled.CreditcardNo	= @AccountNo and 
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo

		Else
		Select AccountNo, Division, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
		(select tblDebit.AccountNo as AccountNo, Calldate, Location as Division,fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate, 1 as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue, Pif, 0  BadDebtRate,  
			0 as BadDebt, (tblCommrateAgent.CommRate * 100) as CommRate, 
			(CASE PifPaid  when 0 then  CAST((( CallRevenue  )  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) 
			 Else CAST((( CallRevenue - isnull(Pif ,0)  -isnull(Nif,0))  *tblCommrateAgent.CommRate)  as Numeric(12,4) ) +isnull( PIf ,0)    End)  as CommPaid
			from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrateAgent with(nolock),  tblFacility with(nolock)  , tblDebit with(nolock)
			 WHERE
							tblcallsbilled.Billtype = tblBilltype.Billtype and
							 tblcallsBilled.errorcode = '0' and 
							tblcallsbilled.Calltype = tblCalltype.Abrev and
							tblcallsbilled.AgentID=  tblCommrateAgent.AgentID and
							tblcallsbilled.Billtype =  tblCommrateAgent.billtype and
							 tblcallsbilled.Calltype = tblCommrateAgent.Calltype and
							tblcallsbilled.FacilityID =  tblFacility.FacilityID and
							 tblcallsbilled.agentID = @agentID and
							tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								tblcallsBilled.CreditcardNo	= @AccountNo and 
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by Division, AccountNo
			Order by  Division, AccountNo

		
 	end	
Else
 	
	Select AccountNo, sum(CallCount) as Callcount, sum(CallDuration) as CallDuration, Sum(BadDebt) as Baddebt, sum(Pif) as Pif, Sum(CommPaid) as CommPaid, sum(CallRevenue) as CallRevenue 
			from
	(select tblDebit.AccountNo as AccountNo, Calldate,  fromno,tono, tblbilltype.Descript as Billtype , tblCallType.Descript as Calltype , RecordDate,  1 as CallCount, dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement )  as CallDuration,  CallRevenue,0  Pif, 0  BadDebtRate,  
		0 as BadDebt, (tblCommrate.CommRate * 100) as CommRate,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,4) ) 
		 Else CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,4) ) + isnull( PIf,0)     End)  as CommPaid
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , tblCommrate with(nolock)  , tblDebit with(nolock)
		WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						tblcallsbilled.facilityID	= @facilityID  And
						--tblcallsbilled.agentID = @agentID and
						tblcallsBilled.CreditcardNo = tblDebit.AccountNo and
								tblcallsbilled.Billtype = '07' and
								tblcallsBilled.CreditcardNo	= @AccountNo and 
								(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  CAST (ResponseCode as int) < 100  and convert (int,duration ) >15
								and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) ) as X
			group by  AccountNo
			Order by   AccountNo
End
