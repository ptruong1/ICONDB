
CREATE PROCEDURE [dbo].[p_Report_PrePaidCalls]

@ToNo varchar(10)
AS

 	SELECT FromNo, ToNo, CAST(sum( CAST(duration as numeric(7,2)))/60 as Numeric(9,2)) as Duration, 
		BillType, RecordDate, sum(CallRevenue) CallRevenue FROM tblCallsBilled  with(nolock)
		WHERE (errorCode = 0) AND 
			 (ToNo =@ToNo)
				group by ToNo, fromNo, BillType, Recorddate

