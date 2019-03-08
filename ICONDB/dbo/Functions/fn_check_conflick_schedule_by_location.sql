-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_check_conflick_schedule_by_location]
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
		select a.FacilityID, a.ApmDate ,@t, a.locationID,  count (a.locationID) ApmBytime,  'Location'  from tblVisitEnduserSchedule a 
		where  a.ApmDate >= cast  (getdate() as date)  and  a.[status] <3 and a.locationID >0 and  DateDiff( Hour,  getdate(),  Dateadd(Minute, DATEPART(minute,apmtime), dateadd(HOUR,datepart(hour, ApmTime),ApmDate))) <24
		and @t >= a.ApmTime and @t < dateadd(MINUTE, a.LimitTime, a.ApmTime )
		group by a.FacilityID,a.locationID, a.ApmDate 
		having  count (a.locationID)  >  (select count(StationType) from  tblVisitPhone with(nolock)  where FacilityID = a.FacilityID and LocationID = a.locationID and StationType=2 and status in (1,5)) ;
		if((select count(*) from @temp) > 0)
			break;
		else
			SET @t = dateadd(MINUTE,10, @t);	
	end
	select @apmNo = a.apmno from tblVisitEnduserSchedule a, @temp b where a.FacilityID = b.FacilityID and a.locationID= b.locationID and a.ApmDate =b.ApmDate and  @t >= a.ApmTime and @t < dateadd(MINUTE, a.LimitTime, a.ApmTime ) and  (note='Inmate Move' or note='Inmate Moved');
	if(@apmNo =0)
		select @apmNo = a.apmno from tblVisitEnduserSchedule a, @temp b where a.FacilityID = b.FacilityID and a.locationID= b.locationID and a.ApmDate =b.ApmDate and  @t >= a.ApmTime and @t < dateadd(MINUTE, a.LimitTime, a.ApmTime );
	return @apmNo;
END
