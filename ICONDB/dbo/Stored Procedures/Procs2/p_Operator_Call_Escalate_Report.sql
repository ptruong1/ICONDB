
CREATE PROCEDURE [dbo].[p_Operator_Call_Escalate_Report]
@fromDate	smalldatetime,
@toDate	smalldatetime,
@AccountNo	varchar(10)
 AS

If(@AccountNo	='') 
	select AdjID, AccountNo ,AdjustDate, Descript    from tblAdjustment with(nolock)  where AdjTypeID =6 and AdjustDate between @fromDate and  @toDate
else
	select AdjID, AccountNo ,AdjustDate, Descript    from tblAdjustment with(nolock)  where AdjTypeID =6 and AdjustDate between @fromDate and  @toDate and AccountNo = @AccountNo

