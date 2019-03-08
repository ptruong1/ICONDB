-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Daily_Debit_revenue_V1]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 	
AS
BEGIN
	Set Nocount On;
	
Select  facilityId, CONVERT(varchar(10), RecordDate,121) as Date, sum(1) as callcount, 
sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	
sum(CallRevenue) Revenue 
  FROM [tblCallsBilled]
  where 
   (RecordDate between @fromDate and dateadd(d,1,@toDate) ) 
  and billType = 7 -- Debit Type
  and convert (int,duration ) >5 
  and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0) 
  group by  facilityId, CONVERT(varchar(10), RecordDate,121)
		 Order by  facilityId, CONVERT(varchar(10), RecordDate,121)

END

