
CREATE PROCEDURE [dbo].[p_update_missing_calls] AS


declare @calldate varchar(10) ,   @duration	int, @projectcode varchar(6),@billtype char(2) 
SET @calldate = right(convert(varchar(10),getdate(),112),6)

select distinct @projectcode = tblcalls.projectCode from tblOutboundCalls,tblcalls
  where  tblcalls.projectCode = tblOutboundCalls.projectcode and  
	 tblcalls.calldate = tblOutboundCalls.calldate and 
	 tblOutboundCalls.Duration >10  and 
	 tblcalls.errorcode='0' and  
	 tblcalls.duration is null  and (tblcalls.billtype ='01' or tblcalls.billtype ='10')  and  datediff(mi,tblOutboundCalls.recorddate,getdate()) >10 and
	 tblcalls.calldate = @calldate and tblcalls.projectCode not in (select projectcode from tblcallsbilled with(nolock) where calldate=@calldate)
select @duration = duration, @billtype =billtype  from tblOutboundCalls with(nolock) where projectcode= @projectcode and calldate=@calldate and  duration >0
If(@duration >0)
	exec  p_update_complete_calls_fail @projectcode	,@calldate, @duration	 ,@billtype

