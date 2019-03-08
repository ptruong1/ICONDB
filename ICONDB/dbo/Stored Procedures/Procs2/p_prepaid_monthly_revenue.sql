
CREATE PROCEDURE [dbo].[p_prepaid_monthly_revenue]
@YYMM varchar(4)

 AS

SET nocount on
Declare @SetUpFee numeric(12,2), @ReplenishFee numeric(12,2) 
--select left(calldate,4)  as YYMM, sum(CallRevenue)  ICONRevenue  from tblcallsbilled with(nolock) where left(calldate,4) =@YYMM  and billtype='10'
--group by left(calldate,4)


select   @SetUpFee=  sum(Amount)  from  tblpurchasedetail  with(nolock) where DetailCat =1  And DetailType =1 and PurchaseNo in (select PurchaseNo from tblpurchase where
 right(convert(varchar(6),PurchaseDate,112),4) =@YYMM )
select  @ReplenishFee =  sum(Amount)   from  tblpurchasedetail  with(nolock) where DetailCat =1  and DetailType =3 and PurchaseNo in (select PurchaseNo from tblpurchase where
 right(convert(varchar(6),PurchaseDate,112),4) =@YYMM)

select left(calldate,4)  as YYMM, sum(CallRevenue)  PrepaidCallRevenue, @SetUpFee  as SetupFee,  @ReplenishFee as ReplenishFee  from tblcallsbilled with(nolock) where left(calldate,4) =@YYMM  and billtype='10'
group by left(calldate,4)
