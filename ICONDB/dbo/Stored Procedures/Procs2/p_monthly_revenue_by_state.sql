-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_monthly_revenue_by_state]
@YYMM char(4)	
AS
BEGIN
	Set Nocount On;
	
	--- Revenue by state
	select  left(calldate,4) YYMM,fromState, count(*) calls, 
	Sum(Duration )/60 MinDuration, Sum(CallRevenue) CallRevenue 
	from leg_Icon.dbo.tblcallsbilled where billtype in ('03','05','07','10','01') 
	 and left(calldate,4) = @YYMM
	group by left(calldate,4),fromState
	order by left(calldate,4),fromState
	

END

