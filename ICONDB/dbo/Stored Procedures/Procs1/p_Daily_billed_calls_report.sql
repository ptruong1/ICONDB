

CREATE PROCEDURE [dbo].[p_Daily_billed_calls_report]
@calldate  char(6)
 AS



Select     FacilityID, AgentID,   calldate  ,   tblBilltype.Descript  as  BillType  , count( FacilityID) calls
	   from tblcallsBilled with(nolock),  tblBilltype with(nolock)
  where   tblcallsBilled.Billtype = tblBilltype.billtype and  
	 tblcallsBilled.errorcode = '0' and 
	 calldate = @calldate  and convert (int,duration ) >10
	Group by FacilityID, AgentID,   calldate  ,   tblBilltype.Descript 

	Order by FacilityID, AgentID,   calldate  ,   tblBilltype.Descript

