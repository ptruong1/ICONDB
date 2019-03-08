
CREATE PROCEDURE [dbo].[p_Report_billed_calls_detail_by_DebitAccount]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@AccountNo	varchar(12)

 AS
set @AccountNo = ltrim(@AccountNo)
If( @AgentID >1  and @facilityID =0 ) 
Begin

	If(@AccountNo <> '') 
		Select    AccountNo as [Prepaid Card]   , fromNo, tono,  CEILING(  duration /60.00   ) as Minutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and  
				-- tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				 tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and
				  tblDebit.AccountNo = tblcallsBilled.billtono  and   tblDebit.AccountNo = @AccountNo	 and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	
	Else
		Select    AccountNo as [Prepaid Card]   , fromNo, tono,CEILING(  duration /60.00   ) as Minutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) 
			   where  tblcallsBilled.AgentID = @AgentID and  
				-- tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				 (RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		 Order by  AccountNo, RecordDate

 End
else
 Begin
	If(@AccountNo <> '') 
		Select    AccountNo as [Prepaid Card]   , fromNo, tono,  CEILING(  duration /60.00   ) as Minutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and  
				-- tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				     tblcallsBilled.errorcode = '0' and 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblDebit.AccountNo =  tblcallsBilled.CreditcardNo   and   tblDebit.AccountNo = @AccountNo	 and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	
	Else
		Select    AccountNo as [Prepaid Card]   , fromNo, tono,CEILING(  duration /60.00   ) as Minutes, 	CallRevenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock) 
			   where  tblcallsBilled.FacilityID = @FacilityID and  
				-- tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
		 Order by  AccountNo, RecordDate
 End

