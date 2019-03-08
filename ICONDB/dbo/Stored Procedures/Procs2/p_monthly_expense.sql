-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_monthly_expense]
	@YYMM varchar(4)
AS
BEGIN
Set Nocount on;

--Network cost unbilled

Declare @tempNetwork table (YYMM char(4), FacilityID int, NetworkCost  Money)
Insert @tempNetwork 

select right (CONVERT(varchar(6),RecordDate,112),4)  [yymm] , FacilityID,    ((count(*) * 0.75) * 0.006) Cost
from  tblcallsunbilled with(nolock) where ErrorType in (1,2,3,19,17,72) 
and  right (CONVERT(varchar(6),RecordDate,112),4) = @YYMM  and facilityID >10
group by right (CONVERT(varchar(6),RecordDate,112),4) ,  FacilityID
order by right (CONVERT(varchar(6),RecordDate,112),4) , FacilityID

---network cost  billtype
Insert @tempNetwork 

select right (CONVERT(varchar(6),RecordDate,112),4)  [yymm] ,FacilityID,  (sum(duration)/60  * 0.006 ) Cost from  tblcallsbilled with(nolock) where
right (CONVERT(varchar(6),RecordDate,112),4) = @YYMM  and facilityID >10 
group by right (CONVERT(varchar(6),RecordDate,112),4),  FacilityID
order by right (CONVERT(varchar(6),RecordDate,112),4),  FacilityID

--Validate cost for LIB
Declare @tempLIB table (YYMM char(4), FacilityID int, LIBCost  Money)
Insert @tempLIB
select right (CONVERT(varchar(6),RecordDate,112),4)  [yymm] ,FacilityID,   (count(*) * 0.10)  LibValidate  from  tblcallsbilled with(nolock) where
right (CONVERT(varchar(6),RecordDate,112),4) = @YYMM and facilityID >10 and billtype in ('05','001')
group by right (CONVERT(varchar(6),RecordDate,112),4),  FacilityID

Insert @tempLIB
select right (CONVERT(varchar(6),RecordDate,112),4)  [yymm] ,FacilityID,  (count(*) * 0.10)    from  tblCallsUnbilled with(nolock) where
right (CONVERT(varchar(6),RecordDate,112),4) = @YYMM and facilityID >10 and billtype in ('05','01') and errorType in (0,17,70,71,72)
group by right (CONVERT(varchar(6),RecordDate,112),4),  FacilityID


---Validate cost for CreditCard
Declare @tempValidate table (YYMM char(4), FacilityID int, CCValidateCost  Money)

Insert  @tempValidate
select right (CONVERT(varchar(6),RecordDate,112),4)  [yymm],FacilityID,  (count(*) * 0.10)  CreditCardValidate  from  tblcallsbilled with(nolock) where
right (CONVERT(varchar(6),RecordDate,112),4) = @YYMM and facilityID >10 and billtype in ('03','05')
group by right (CONVERT(varchar(6),RecordDate,112),4),  FacilityID

Insert  @tempValidate
select right (CONVERT(varchar(6),RecordDate,112),4)  [yymm] ,FacilityID,   (count(*) * 0.10) CreditCardValidate   from  tblCallsUnbilled with(nolock) where
right (CONVERT(varchar(6),RecordDate,112),4) = @YYMM and facilityID >10 and billtype in ('03','05') and errorType in (0,17,70,71,72)
group by right (CONVERT(varchar(6),RecordDate,112),4),  FacilityID


select a.YYMM, a.FacilityID,  sum(a.NetworkCost) NetworkCost , SUM(b.LIBCost) LIBCost, SUM(c.CCValidateCost)  CCValidateCost from @tempNetwork  a ,@tempLIB b  ,@tempValidate c
	where a.FacilityID = b.FacilityID and
		  a.FacilityID = c.FacilityID 
	group by a.YYMM, a.FacilityID 
	order by a.FacilityID ;

END

