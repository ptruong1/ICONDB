-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION fn_check_conflick_schedule_by_visitor_area
(	
)
RETURNS int
AS
BEGIN
	Declare @t time(0), @apmNo int;
	SET @t = '07:00:00';
	SET @apmNo =0;
	Declare @temp as table(FacilityID int, ApmDate  date, ApmTime varchar(8), locationID int, ApmCount  int, Reason varchar(20))   ;
	While @t < '22:00:00'
	Begin
		Insert @temp
		select a.FacilityID, a.ApmDate ,  @t, 0, count (a.ApmTime) ApmBytime ,'Visit Area'    from tblVisitEnduserSchedule a 
		where  a.ApmDate >= cast  (getdate() as date)  and a.visitType=1 and a.[status] <3  and  DateDiff( Hour,  getdate(),  Dateadd(Minute, DATEPART(minute,apmtime), dateadd(HOUR,datepart(hour, ApmTime),ApmDate))) <25
		group by a.FacilityID,ApmDate 
		having  count (a.ApmTime)  >  (select count(StationType) from  tblVisitPhone with(nolock) where FacilityID = a.FacilityID and StationType=1 and status in (1,5));
		if((select count(*) from @temp) > 0)
			break;
		SET @t = dateadd(MINUTE,10, @t);	
	end
	select top 1 @apmNo = a.apmno from tblVisitEnduserSchedule a, @temp b where a.FacilityID = b.FacilityID and  a.ApmDate =b.ApmDate and  @t >= a.ApmTime and @t < dateadd(MINUTE, a.LimitTime, a.ApmTime ) and visittype=1;
	return @apmNo;
END
