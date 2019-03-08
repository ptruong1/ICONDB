-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_check_inmate_move_conflict_schedule]
	
AS
BEGIN
	
	Declare @FacilityID int, @InmateID varchar(12)  ,@LastLocationID  int, @CurrentLocationID int,  @LocationID int, @VisitType int, @Email varchar(50), @VisitorName varchar(40),
	@scheduleDate smalldatetime,@ScheduleTime time(0), @InmateName varchar(50), @ContactPhone varchar(10), @apmNo int , @FacilityName varchar(150), @VisitorID int;
	SET @FacilityID =0;
	SET  @FacilityName ='';
	SET @VisitorName ='';
	SET @apmNo =0;
	SET @VisitorID =0;
	
	Declare @temp as table(FacilityID int, ApmDate  date, ApmTime varchar(8), locationID int, ApmCount  int)   ;

	Insert @temp
	-- by visitor area
	select a.FacilityID, a.ApmDate , a.ApmTime, 0, count (a.ApmTime) ApmBytime    from tblVisitEnduserSchedule a 
	where  a.ApmDate >= cast  (getdate() as date)  and a.visitType=1 and a.[status] <3 
	group by a.FacilityID,ApmDate , ApmTime
	having  count (a.ApmTime)  >  (select count(StationType) from  tblVisitPhone with(nolock) where FacilityID = a.FacilityID and StationType=1 and status=1);

	---by Location
	Insert @temp
	select a.FacilityID, a.ApmDate , a.ApmTime, a.locationID, count (a.ApmTime) ApmBytime  from tblVisitEnduserSchedule a 
	where  a.ApmDate >= cast  (getdate() as date)  and  a.[status] <3 and a.locationID >0 -- and a.RequestedTime > '8/7/2018'
	group by a.FacilityID,a.locationID, a.ApmDate , a.ApmTime
	having  count (a.ApmTime)  >  (select count(StationType) from  tblVisitPhone with(nolock)  where FacilityID = a.FacilityID and LocationID = a.locationID and StationType=2 and status=1) ;


	Insert @temp
	select a.FacilityID, a.ApmDate , DATEADD(MINUTE, a.LimitTime, a.ApmTime), a.locationID, count ( DATEADD(MINUTE, a.LimitTime, a.ApmTime)) ApmBytime  from tblVisitEnduserSchedule a 
	where  a.ApmDate >= cast  (getdate() as date)  and  a.[status] <3 and a.locationID >0 -- and a.RequestedTime > '8/7/2018'
	group by a.FacilityID,a.locationID, a.ApmDate ,  DATEADD(MINUTE, a.LimitTime, a.ApmTime)
	having  count( DATEADD(MINUTE, a.LimitTime, a.ApmTime))  >  (select count(StationType) from  tblVisitPhone with(nolock)  where FacilityID = a.FacilityID and LocationID = a.locationID and StationType=2 and status=1) ;

	Insert @temp
	select a.FacilityID, a.ApmDate , DATEADD(MINUTE, -a.LimitTime, a.ApmTime), a.locationID, count ( DATEADD(MINUTE,- a.LimitTime, a.ApmTime)) ApmBytime  from tblVisitEnduserSchedule a 
	where  a.ApmDate >= cast  (getdate() as date)  and  a.[status] <3 and a.locationID >0 -- and a.RequestedTime > '8/7/2018'
	group by a.FacilityID,a.locationID, a.ApmDate ,  DATEADD(MINUTE, -a.LimitTime, a.ApmTime)
	having  count( DATEADD(MINUTE, -a.LimitTime, a.ApmTime))  >  (select count(StationType) from  tblVisitPhone with(nolock)  where FacilityID = a.FacilityID and LocationID = a.locationID and StationType=2 and status=1) ;

	Select @FacilityID=  FacilityID, @scheduleDate= ApmDate , @ScheduleTime=  ApmTime  from @temp ;

	If(@FacilityID >0)
	 Begin 
		select @apmNo =apmno,   @LocationID = locationID,  @VisitType= visitType,@scheduleDate= ApmDate, @ScheduleTime = ApmTime,  @InmateName= InmateName,@ContactPhone= EndUserID,@VisitorID = VisitorID
	    From tblVisitEnduserSchedule with(nolock)
		where FacilityID=  @FacilityID and ApmDate= @scheduleDate and  @ScheduleTime= ApmTime and (note='Inmate Move' or note='Inmate Moved') and [status] in (1,2)	order by RequestedTime desc;
		If (@apmNo =0)
		 Begin
			select @apmNo =apmno,   @LocationID = locationID,  @VisitType= visitType,@scheduleDate= ApmDate, @ScheduleTime = ApmTime,  @InmateName= InmateName,@ContactPhone= EndUserID,  @VisitorID = VisitorID
			From tblVisitEnduserSchedule with(nolock)
			where FacilityID=  @FacilityID and ApmDate= @scheduleDate and  @ScheduleTime= ApmTime and [status] in (1,2)	order by RequestedTime desc;

		 End
        If(@apmNo > 0)
		begin
			Update tblVisitEnduserSchedule set status = 4, CancelDate = getdate(), CancelBy = 'Auto' where ApmNo = @apmNo;
			select @FacilityName  = [location] from tblFacility with(nolock) where FacilityID = @FacilityID ; 
			select @Email = email   from tblEndusers with(nolock) where UserName = @ContactPhone;
			select @VisitorName = Isnull(Vfirstname,'')  + ' ' + isnull(VLastName,'') from tblvisitors with(nolock) where visitorID = @visitorID;
		End
	 end
	 Select  @apmNo as apmno,   @FacilityName  as FacilityName  ,  @VisitType as visitType,  Convert(varchar(10), @scheduleDate,101) as ApmDate,
	 right('0' + ltrim(right(convert(varchar,  cast(@ScheduleTime as dateTime), 100), 7)), 7)   as ApmTime, 
	 @InmateName as InmateName,@ContactPhone as EndUserID, @Email as ContactEmail, @VisitorName as VisitorName ;
END
