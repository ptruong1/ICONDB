-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[p_monthly_revenue_commission_by_facility_bk]
@YYMM char(4)	
AS
BEGIN
	Set Nocount On;
	Declare  @Revenue table(YYMM char(4), facilityID int, Location varchar(100), Revenue money); 
	Insert  @Revenue (YYMM , facilityID , Location , Revenue )
	select left(calldate,4) YYMM, c.facilityID, location, sum(CallRevenue) MonthlyRevenue 
	from leg_icon.dbo.tblcallsbilled  c with(nolock) ,leg_icon.dbo.tblFacility f  with(nolock) 
	where c.facilityID = f.facilityID and left(calldate,4) = @YYMM and billtype in ('03','05','07','10','01')  and f.AgentID <100
	group by left(calldate,4), location, c.facilityID
	order by left(calldate,4), location , c.facilityID;

--Setup Fee
    Declare  @SetupFee table(YYMM char(4), facilityID int, Location varchar(100), SetUpfee money); 
	Insert  @SetupFee( YYMM ,facilityID , Location , SetUpfee )
	select  right(convert(varchar(6),PurchaseDate,112),4) MMYY ,  f.facilityID, location, sum(Amount) MonthlySetUpFee  from leg_icon.dbo.tblfacility f  with(nolock), leg_icon.dbo.tblPrepaid a,leg_icon.dbo.tblpurchase b ,  leg_icon.dbo.tblpurchasedetail  c
	 where f.facilityID = a.facilityID and f.AgentID <100  and
	 a.phoneno= b.AccountNo and b.purchaseNo = c.PurchaseNo and
	 DetailCat =1  And DetailType =1 and 
	right (CONVERT(varchar(6),PurchaseDate,112),4) = @YYMM 
	 group by right(convert(varchar(6),PurchaseDate,112),4),location, f.facilityID
	 order by right(convert(varchar(6),PurchaseDate,112),4),location, f.facilityID;
--Replenish Fee
    Declare  @ReplenishFee table(YYMM char(4), facilityID int, Location varchar(100), ReplenishFee money); 
	Insert  @ReplenishFee ( YYMM , facilityID, Location , ReplenishFee  )
	 select  right(convert(varchar(6),PurchaseDate,112),4) MMYY , f.facilityID ,  location, sum(Amount) MonthlyReplenishFee  from leg_icon.dbo.tblfacility f  with(nolock), leg_icon.dbo.tblPrepaid a,leg_icon.dbo.tblpurchase b ,  leg_icon.dbo.tblpurchasedetail  c
	 where f.facilityID = a.facilityID and f.AgentID <100 and
	 a.phoneno= b.AccountNo and b.purchaseNo = c.PurchaseNo and
	 DetailCat =1  And DetailType =3 and 
	right (CONVERT(varchar(6),PurchaseDate,112),4) = @YYMM 
	 group by right(convert(varchar(6),PurchaseDate,112),4),location, f.facilityID
	 order by right(convert(varchar(6),PurchaseDate,112),4),location, f.facilityID;


	---- credit card fee
	Declare  @CreditCardFee table(YYMM char(4), facilityID int, Location varchar(100), CreditCardFee money); 
	Insert  @CreditCardFee ( YYMM , facilityID , Location , CreditCardFee )
	select left(calldate,4) YYMM , f.facilityID,location ,  count(*) * isnull(s.FeeAmount,1.95)   as CreditCardFee
	from leg_icon.dbo.tblcallsbilled  c with(nolock) join leg_icon.dbo.tblFacility f with(nolock) on (c.facilityID = f.facilityID ) left outer join Leg_icon.dbo.tblFees s on (f.facilityID =s.facilityID )
	where  left(calldate,4) = @YYMM  and billtype in ('03','05') and FeeDetailID=10 and f.AgentID <100
	group by left(calldate,4),location,  s.FeeAmount,  f.facilityID
	order by left(calldate,4),location, f.facilityID;

	--- Commission
	Declare  @Commision table(YYMM char(4), facilityID int, Location varchar(100), CallRevenue money,  CommRate  numeric(4,2)); 
	Insert  @Commision  (YYMM , facilityID , Location , CallRevenue )
	select left(calldate,4) YYMM, f.facilityID , location, sum(CallRevenue) 
	from leg_icon.dbo.tblcallsbilled  c with(nolock) ,leg_icon.dbo.tblFacility f   with(nolock)
	where c.facilityID = f.facilityID and left(calldate,4) = @YYMM and c.billtype in ('03','05','07','10','01')  and errorCode ='0'  and f.AgentID <100
	group by left(calldate,4), location, f.facilityID
	order by left(calldate,4), location , f.facilityID;
	Update @Commision set CommRate = a.CommRate from tblCommRate a , @Commision b
	where a.FacilityID =b.facilityID and a.BillType ='01';

	select a.FacilityID, a.location, a.Revenue,b.SetUpfee,c.ReplenishFee, d.CreditCardFee, (f.CallRevenue * isnull(f.CommRate,0)) Commission   from  @Revenue  a,  @SetupFee b,  @ReplenishFee c, @CreditCardFee d ,  @Commision f
	where a.facilityID = b.facilityID and 
		   a.facilityID =c.facilityID and
		    a.facilityID =d.facilityID and
			a.facilityID = f.facilityID
			order by a.FacilityID


END
