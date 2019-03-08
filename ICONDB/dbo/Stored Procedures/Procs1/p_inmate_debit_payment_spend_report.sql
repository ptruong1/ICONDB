-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_inmate_debit_payment_spend_report]
@FacilityID int,
@FromDate varchar(10),
@ToDate	   varchar(10),
@InmateID  varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @timezone smallint;
    Declare @t as table(InmateID varchar(12), Activity varchar(30), ActivityID bigint, ActivityDate datetime, Amount smallmoney, PreviousBalance smallmoney, Balance smallmoney);
	SET @timezone = 0;
	Select  @timezone = timezone from tblfacility with(nolock) where facilityID = @facilityID;
	if(@FromDate <>'' and @ToDate	<> '' and @InmateID <>'')
	 begin
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount , PreviousBalance , Balance)
		select InmateID, 'Payment',  paymentID, dateadd(HOUR,@timezone, PaymentDate), Amount,  LastBalance, (Amount + LastBalance) 
			FROM  tblDebitPayments with(nolock) where facilityID = @FacilityID and InmateID = @InmateID and PaymentDate>= @FromDate and PaymentDate<=dateadd(d,1,@ToDate) order by paymentID;
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select InmateID, 'Phone Call', RecordID,RecordDate, CallRevenue from tblcallsbilled with(nolock) where facilityID = @facilityID and InmateID = @InmateID and billtype='07' and RecordDate >=@fromDate and RecordDate <=@toDate order by RecordID ;
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select @InmateID,'Adjustment',a.AdjID , DATEADD(HOUR,@timezone, a.AdjustDate), a.AdjAmount from tblAdjustment a with(nolock)  inner join tbldebit b with(nolock) on (a.AccountNo = b.AccountNo) and b.FacilityID= @FacilityID and b.InmateID= @InmateID and a.AdjustDate >=@FromDate and a.AdjustDate <=dateadd(d,1,@ToDate);
	 end
	Else if(@FromDate <>'' and @ToDate	<> '' )
	 begin
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount , PreviousBalance , Balance)
		select InmateID, 'Payment',  paymentID, dateadd(HOUR,@timezone, PaymentDate), Amount,  LastBalance, (Amount + LastBalance) 
			FROM  tblDebitPayments with(nolock) where facilityID = @FacilityID and  PaymentDate>= @FromDate and PaymentDate<=dateadd(d,1,@ToDate) order by paymentID;
        Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select InmateID, 'Phone Call', RecordID,RecordDate, CallRevenue from tblcallsbilled with(nolock) where facilityID = @facilityID and billtype='07' and RecordDate >=@fromDate and RecordDate <=dateadd(d,1,@ToDate) order by RecordID ;
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select @InmateID,'Adjustment',a.AdjID , DATEADD(HOUR,@timezone, a.AdjustDate), a.AdjAmount from tblAdjustment a with(nolock)  inner join tbldebit b with(nolock) on (a.AccountNo = b.AccountNo) and b.FacilityID= @FacilityID  and a.AdjustDate >=@FromDate and a.AdjustDate <=dateadd(d,1,@ToDate);
	 end
    else if(@FromDate <>''  )
	 begin
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount , PreviousBalance , Balance)
		select InmateID, 'Payment',  paymentID, dateadd(HOUR,@timezone, PaymentDate), Amount,LastBalance, (Amount + LastBalance) 
			FROM  tblDebitPayments with(nolock) where facilityID = @FacilityID and  PaymentDate>= @FromDate order by paymentID;
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select InmateID, 'Phone Call', RecordID,RecordDate, CallRevenue from tblcallsbilled with(nolock) where facilityID = @facilityID and billtype='07' and  RecordDate >=@fromDate order by RecordID ;
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select @InmateID,'Adjustment',a.AdjID , DATEADD(HOUR,@timezone, a.AdjustDate), a.AdjAmount from tblAdjustment a with(nolock)  inner join tbldebit b with(nolock) on (a.AccountNo = b.AccountNo) and b.FacilityID= @FacilityID and a.AdjustDate >=@FromDate ;
	 end
	 else 
	 begin
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount , PreviousBalance , Balance)
		select InmateID, 'Payment',  paymentID, dateadd(HOUR,@timezone, PaymentDate), Amount, LastBalance, (Amount + LastBalance) 
			FROM  tblDebitPayments with(nolock) where facilityID = @FacilityID order by paymentID;
        Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select InmateID, 'Phone Call', RecordID,RecordDate, CallRevenue from tblcallsbilled with(nolock) where facilityID = @facilityID and billtype='07' order by RecordID ;
		Insert @t(InmateID, Activity , ActivityID , ActivityDate ,Amount )
		select @InmateID,'Adjustment',a.AdjID , DATEADD(HOUR,@timezone, a.AdjustDate), a.AdjAmount from tblAdjustment a with(nolock)  inner join tbldebit b with(nolock) on (a.AccountNo = b.AccountNo) and b.FacilityID= @FacilityID;
	 end

	 select * from @t order by InmateID,   ActivityDate ,  ActivityID


	 
END

