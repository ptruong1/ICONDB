-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_facility_cardless_debit_order_report] 
@FacilityID int,
@InmateID varchar(12),
@FromDate	varchar(10),
@ToDate		varchar(10)

AS
BEGIN
	if(@InmateID <>'' and @FromDate <>'' and @ToDate <>'')
		select InmateID, orderNo as TransactionID, OrderDate as TransDate, Amount  from  tblDebitCardOrder  with(nolock)
			where FacilityID= @FacilityID and 
					InmateID = @InmateID and 
					OrderDate >=@FromDate  and 
					OrderDate <= dateadd(d,1,@ToDate)
					order by OrderNo;
	else if( @FromDate <>'' and @ToDate <>'')
		select InmateID, orderNo as TransactionID, OrderDate as TransDate, Amount  from  tblDebitCardOrder  with(nolock)
			where FacilityID= @FacilityID and 
					OrderDate >=@FromDate  and 
					OrderDate <=dateadd(d,1,@ToDate) 
					order by OrderNo;
	--else if(@InmateID <>'' and @FromDate <>'')
	--	select InmateID, orderNo as TransactionID, OrderDate as TransDate, Amount  from  tblDebitCardOrder  with(nolock)
	--		where FacilityID= @FacilityID and 
	--				InmateID = @InmateID and 
	--				OrderDate >=@FromDate  				
	--				order by OrderNo;
	else if(@InmateID <>'' )
		select InmateID, orderNo as TransactionID, OrderDate as TransDate, Amount  from  tblDebitCardOrder  with(nolock)
			where FacilityID= @FacilityID and 
					InmateID = @InmateID 	
					order by OrderNo;
	else
		select InmateID, orderNo as TransactionID, OrderDate as TransDate, Amount  from  tblDebitCardOrder  with(nolock)
			where FacilityID= @FacilityID
					order by OrderNo;

END

