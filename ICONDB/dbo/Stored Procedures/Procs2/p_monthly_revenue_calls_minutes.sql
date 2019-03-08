-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_monthly_revenue_calls_minutes]
@YYMM char(4)	
AS
BEGIN
	Set Nocount On;
	
	 ---Total Revenue
	select  left(calldate,4) YYMM, count(*) calls, 
	Sum(Duration )/60 MinDuration, Sum(CallRevenue) CallRevenue 
	from leg_Icon.dbo.tblcallsbilled where billtype in ('03','05','07','10','01') 
	 and left(calldate,4) = @YYMM
	group by left(calldate,4)
	order by left(calldate,4);
	
		 

END

