-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Daily_Debit_revenue]
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime  -- Required 	
AS
BEGIN
	Set Nocount On;
	
	--per billtype
Select  tblcallsBilled.facilityId, CONVERT(varchar(10), RecordDate,121) as Date, sum(dbo.fn_calculateBillableTime (duration, minDuration ,minIncrement)) as TotalMinutes, 	sum(CallRevenue) Revenue 
			  from tblcallsBilled  with(nolock),  tblDebit  with(nolock)
			   where  
			   errorcode = '0' and
			   
			 				 tblDebit.FacilityID =  tblcallsBilled.FacilityID  And 
				(RecordDate between @fromDate and dateadd(d,1,@todate) ) and  tblDebit.AccountNo = tblcallsBilled.CreditcardNo   and convert (int,duration ) >5   
			and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
			group by  tblcallsBilled.facilityId, CONVERT(varchar(10), RecordDate,121)
		 Order by  tblcallsBilled.facilityId, CONVERT(varchar(10), RecordDate,121)

END

