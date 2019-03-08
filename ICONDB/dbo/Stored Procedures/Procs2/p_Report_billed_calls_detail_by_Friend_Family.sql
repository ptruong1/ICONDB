
CREATE PROCEDURE [dbo].[p_Report_billed_calls_detail_by_Friend_Family]
@FacilityID	int,
@AgentID	int,
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime , -- Required 
@AccountNo	varchar(10)

 AS
set @AccountNo = ltrim(@AccountNo)
If(@AccountNo <> '') 
	Select    PhoneNo as [Account No]  , fromNo, tono,  CEILING(  duration /60.00   ) as Minutes, 	CallRevenue 
		  from tblcallsBilled  with(nolock),  tblPrepaid  with(nolock) 
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			-- tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and   tblPrepaid.PhoneNo = tblcallsBilled.billtono  and    tblPrepaid.PhoneNo = @AccountNo	and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))

Else
	Select    PhoneNo as [Account No]   , fromNo, tono,CEILING(  duration /60.00   ) as Minutes, 	CallRevenue 
		  from tblcallsBilled  with(nolock),  tblPrepaid   with(nolock) 
		   where  tblcallsBilled.FacilityID = @FacilityID and  
			   tblcallsBilled.errorcode = '0' and 
			-- tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
			(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblPrepaid.PhoneNo = tblcallsBilled.billtono   and convert (int,duration ) >15   AND ( (tblcallsBilled.billtype in ( '01','00','02','10'))  or  (tblcallsBilled.billtype in ('03','05') and complete =2))
	 Order by  PhoneNo, RecordDate

