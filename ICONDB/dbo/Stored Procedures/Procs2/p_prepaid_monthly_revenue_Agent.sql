
CREATE PROCEDURE [dbo].[p_prepaid_monthly_revenue_Agent]
@YYMM varchar(4),
@AgentID	int
 AS

SET nocount on
Declare @SetUpFee numeric(12,2)  ,  @SetUpTrans int , @ReplenishFee numeric(12,2) , @ReplenishTrans int
--select left(calldate,4)  as YYMM, sum(CallRevenue)  ICONRevenue  from tblcallsbilled with(nolock) where left(calldate,4) =@YYMM  and billtype='10'
--group by left(calldate,4)
select @SetUpFee=  sum(Amount) , @SetUpTrans= count (*)    from  tblpurchasedetail  with(nolock),tblpurchase , tblPrepaid with(nolock)  , tblFacility with(nolock)
where DetailCat =1  And DetailType =1 and tblpurchasedetail.PurchaseNo = tblpurchase.PurchaseNo 
and right(convert(varchar(6),PurchaseDate,112),4) =@YYMM
and tblPrepaid.PhoneNo =tblpurchase.AccountNo  and tblFacility.FacilityID =tblPrepaid.FacilityID 
and tblFacility.AgentID =@AgentID and tblPrepaid.paymentTypeID=1
group by  right(convert(varchar(6),PurchaseDate,112),4) 

select    @ReplenishFee =sum(Amount) , @ReplenishTrans = count(*)   from  tblpurchasedetail  with(nolock),tblpurchase , tblPrepaid with(nolock)  , tblFacility with(nolock)
where DetailCat =1  And DetailType =3 and tblpurchasedetail.PurchaseNo = tblpurchase.PurchaseNo 
and right(convert(varchar(6),PurchaseDate,112),4) =@YYMM
and tblPrepaid.PhoneNo =tblpurchase.AccountNo  and tblFacility.FacilityID =tblPrepaid.FacilityID 
and tblFacility.AgentID =@AgentID and tblPrepaid.paymentTypeID=1
group by  right(convert(varchar(6),PurchaseDate,112),4) 

Select @YYMM as YYMM, @SetUpTrans as SetUpTrans, @SetUpFee  As SetupAmount, @ReplenishTrans as ReplenishTrans  , @ReplenishFee as ReplenishAmount
