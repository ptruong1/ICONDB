-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_prepaid_monthly_revenue_by_facility]
@YYMM char(4)	
AS
BEGIN
	Set Nocount On
	select left(calldate,4) YYMM, location, sum(CallRevenue) MonthlyRevenue 
	from leg_Icon.dbo.tblcallsbilled  c with(nolock) ,leg_Icon.dbo.tblFacility f 
	where c.facilityID = f.facilityID and left(calldate,4) = @YYMM
	group by left(calldate,4), location
	order by left(calldate,4), location ;
	--per billtype
select left(calldate,4) YYMM, location, billtype, sum(CallRevenue) MonthlyRevenue 
	from leg_Icon.dbo.tblcallsbilled  c with(nolock) ,leg_Icon.dbo.tblFacility f 
	where c.facilityID = f.facilityID and  left(calldate,4) = @YYMM and billtype in ('10','01','03','05','07')
	group by left(calldate,4), location, billtype
	order by left(calldate,4), location ,billtype;
--Setup Fee

	select  right(convert(varchar(6),PurchaseDate,112),4) MMYY ,  location, sum(Amount) MonthlySetUpFee  from leg_Icon.dbo.tblfacility f, leg_Icon.dbo.tblPrepaid a,leg_Icon.dbo.tblpurchase b ,  leg_Icon.dbo.tblpurchasedetail  c
	 where f.facilityID = a.facilityID and
	 a.phoneno= b.AccountNo and b.purchaseNo = c.PurchaseNo and
	 DetailCat =1  And DetailType =1 and 
	right (CONVERT(varchar(6),PurchaseDate,112),4) = @YYMM 
	 group by right(convert(varchar(6),PurchaseDate,112),4),location
	 order by right(convert(varchar(6),PurchaseDate,112),4),location;
	 --Replenish Fee
	 select  right(convert(varchar(6),PurchaseDate,112),4) MMYY ,  location, sum(Amount) MonthlyReplenishFee  from leg_Icon.dbo.tblfacility f, leg_Icon.dbo.tblPrepaid a,leg_Icon.dbo.tblpurchase b ,  leg_Icon.dbo.tblpurchasedetail  c
	 where f.facilityID = a.facilityID and
	 a.phoneno= b.AccountNo and b.purchaseNo = c.PurchaseNo and
	 DetailCat =1  And DetailType =3 and 
	right (CONVERT(varchar(6),PurchaseDate,112),4) = @YYMM 
	 group by right(convert(varchar(6),PurchaseDate,112),4),location
	 order by right(convert(varchar(6),PurchaseDate,112),4),location;
	 
	 ---Total Revenue
	select  left(calldate,4) YYMM, count(*) calls, 
	Sum(Duration )/60 MinDuration, Sum(CallRevenue) CallRevenue 
	from leg_Icon.dbo.tblcallsbilled where billtype in ('03','05','07','10','01') 
	 and left(calldate,4) = @YYMM
	group by left(calldate,4)
	order by left(calldate,4);
	
		 ---Total Revenue, calls by CC,  
	 
	select  left(calldate,4) YYMM,facilityID, count(*) calls, 
	Sum(Duration )/60 MinDuration, Sum(CallRevenue) CallRevenue 
	from leg_Icon.dbo.tblcallsbilled where billtype in ('03','05') 
	 and left(calldate,4) = @YYMM
	group by left(calldate,4),facilityID
	order by left(calldate,4),facilityID;
	--- Revenue by state
	select  left(calldate,4) YYMM,fromState, count(*) calls, 
	Sum(Duration )/60 MinDuration, Sum(CallRevenue) CallRevenue 
	from leg_Icon.dbo.tblcallsbilled where billtype in ('03','05','07','10','01') 
	 and left(calldate,4) = @YYMM
	group by left(calldate,4),fromState
	order by left(calldate,4),fromState;
	---- credit card fee
	/*
	select left(calldate,4) YYMM,location , count(*) * 1.95  as CreditCardFee
	from leg_Icon.dbo.tblcallsbilled  c with(nolock) ,leg_Icon.dbo.tblFacility f 
	where c.facilityID = f.facilityID and  left(calldate,4) = @YYMM and billtype in ('03','05')
	group by left(calldate,4),location
	order by left(calldate,4),location
	*/
		select left(calldate,4) YYMM,location , count(*) TransCount,isnull(s.FeeAmount,1.95) FeeCharge, count(*) * isnull(s.FeeAmount,1.95)   as CreditCardFee
	from leg_Icon.dbo.tblcallsbilled  c with(nolock)  join leg_Icon.dbo.tblFacility f on ( c.facilityID = f.facilityID) left join leg_Icon.dbo.tblFees s
	on  (f.facilityID =s.facilityID) where  left(calldate,4) = @YYMM and billtype in ('03','05') and FeeDetailID=10
	group by left(calldate,4),location,  s.FeeAmount
	order by left(calldate,4),location;

	-----------call Revenue by Calltype
	select left(calldate,4) YYMM, location, Calltype, sum(CallRevenue) MonthlyRevenue 
	from leg_Icon.dbo.tblcallsbilled  c with(nolock) ,leg_Icon.dbo.tblFacility f 
	where c.facilityID = f.facilityID and  left(calldate,4) = @YYMM and billtype in ('10','01','03','05','07')
	group by left(calldate,4), location, Calltype
	order by left(calldate,4), location ,Calltype;

END

