-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_daily_overbooking_report]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


Declare @temp as table(FacilityID int, ApmDate  date, ApmTime varchar(8), locationID int, ApmCount  int)   ;

Insert @temp
-- by visitor area
select a.FacilityID, a.ApmDate , a.ApmTime, 0, count (a.ApmTime) ApmBytime    from tblVisitEnduserSchedule a 
where  a.ApmDate >= cast  (getdate() as date)  and a.visitType=1 and a.status <3 
group by a.FacilityID,ApmDate , ApmTime
having  count (a.ApmTime)  >  (select count(StationType) from  tblVisitPhone  where FacilityID = a.FacilityID and StationType=1 and status=1);

---by Location
Insert @temp
select a.FacilityID, a.ApmDate , a.ApmTime, a.locationID, count (a.ApmTime) ApmBytime  from tblVisitEnduserSchedule a 
where  a.ApmDate >= cast  (getdate() as date)  and  a.status <3 and a.locationID >0 -- and a.RequestedTime > '8/7/2018'
group by a.FacilityID,a.locationID, a.ApmDate , a.ApmTime
having  count (a.ApmTime)  >  (select count(StationType) from  tblVisitPhone  where FacilityID = a.FacilityID and LocationID = a.locationID and StationType=2 and status=1) ;
Select FacilityID,  ApmDate ,  ApmTime, ApmCount  from @temp ;




END
