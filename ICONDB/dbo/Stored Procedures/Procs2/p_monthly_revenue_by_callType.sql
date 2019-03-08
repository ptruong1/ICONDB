-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_monthly_revenue_by_callType]
@YYMM char(4)	
AS
BEGIN
	Set Nocount On;
	
	select left(calldate,4) YYMM, location, Calltype, sum(CallRevenue) MonthlyRevenue 
	from leg_Icon.dbo.tblcallsbilled  c with(nolock) ,leg_Icon.dbo.tblFacility f 
	where c.facilityID = f.facilityID and  left(calldate,4) = @YYMM and billtype in ('10','01','03','05','07')
	group by left(calldate,4), location, Calltype
	order by left(calldate,4), location ,Calltype ;

END

