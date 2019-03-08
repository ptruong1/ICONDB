-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_threshold_creditcard_call_report]
@day int , 	
@threshold int
AS
BEGIN


select  FacilityID, InmateID, Tono, creditcardno, count(*) TotalCount , sum(CallRevenue) TotalCharge
	 from tblCallsBilled with(nolock) where billtype in ('03','05') and DATEDIFF(day,recorddate, getdate() ) < @day
	 group by  InmateID, FacilityID, tono, creditcardno
	 having count(*)  > @threshold
	
END

