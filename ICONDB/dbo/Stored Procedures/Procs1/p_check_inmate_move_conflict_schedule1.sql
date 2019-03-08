-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_check_inmate_move_conflict_schedule1]
	
AS
BEGIN
	
	Declare @AgentID int,@FacilityID int, @InmateID varchar(12)  ,@LastLocationID  int, @CurrentLocationID int,  @LocationID int, @VisitType int, @Email varchar(50), @VisitorName varchar(40),
	@scheduleDate smalldatetime,@apmDateTime smalldatetime, @ScheduleTime time(0), @InmateName varchar(50), @ContactPhone varchar(10), @apmNo int , @FacilityName varchar(150), @VisitorID int,
    @FacilityEmail varchar(300),@iCONurl varchar(100), @CancelReason varchar(50), @ContactEmail varchar(60), @ContactEmail2 varchar(60), @ContactEmail3 varchar(60), @Reason varchar(20) ;
	SET @FacilityID =0;
	SET  @FacilityName ='';
	SET @VisitorName ='';
	SET @apmNo =0;
	SET @VisitorID =0;
	SET @CancelReason ='Device Offline';
	SET @ContactEmail ='';
	SET @ContactEmail2 = '';
	SET @ContactEmail3 = '';
	SET @Reason  ='';
	SET  @iCONurl = 'https://inmate.legacyicon.com'
	Declare @temp as table(FacilityID int, ApmDate  date, ApmTime varchar(8), locationID int, ApmCount  int, Reason varchar(20))   ;

	Insert @temp
	-- by visitor area
	select a.FacilityID, a.ApmDate , a.ApmTime, 0, count (a.ApmTime) ApmBytime ,@CancelReason    from tblVisitEnduserSchedule a 
	where  a.ApmDate >= cast  (getdate() as date)  and a.visitType=1 and a.[status] <3  and  DateDiff( Hour,  getdate(),  Dateadd(Minute, DATEPART(minute,apmtime), dateadd(HOUR,datepart(hour, ApmTime),ApmDate))) <25
	group by a.FacilityID,ApmDate , ApmTime
		having  count (a.ApmTime)  >  (select count(StationType) from  tblVisitPhone with(nolock) where FacilityID = a.FacilityID and StationType=1 and status in (1,5));
	---by Location
	Insert @temp
	select a.FacilityID, a.ApmDate , a.ApmTime, a.locationID, count (a.ApmTime) ApmBytime, 'Location'  from tblVisitEnduserSchedule a 
	where  a.ApmDate >= cast  (getdate() as date)  and  a.[status] <3 and a.locationID >0 and  DateDiff( Hour,  getdate(),  Dateadd(Minute, DATEPART(minute,apmtime), dateadd(HOUR,datepart(hour, ApmTime),ApmDate))) <25
	group by a.FacilityID,a.locationID, a.ApmDate , a.ApmTime
	having  count (a.ApmTime)  >  (select count(StationType) from  tblVisitPhone with(nolock)  where FacilityID = a.FacilityID and LocationID = a.locationID and StationType=2 and status in (1,5)) ;
	
    Select @FacilityID=  FacilityID, @scheduleDate= ApmDate , @ScheduleTime=  ApmTime, @Reason = Reason, @LocationID= locationID  from @temp ;
	If(@FacilityID >0)
	 Begin 
	    if(@Reason = 'Location' )
		 begin
			    select top 1 @apmNo =apmno,   @LocationID = locationID,  @VisitType= visitType,@scheduleDate= ApmDate, @ScheduleTime = ApmTime,@InmateID=InmateID, @InmateName= InmateName,@ContactPhone= EndUserID,@VisitorID = VisitorID
				From tblVisitEnduserSchedule with(nolock)
				where FacilityID=  @FacilityID and ApmDate= @scheduleDate and  @ScheduleTime= ApmTime and locationID =@LocationID  and (note='Inmate Move' or note='Inmate Moved') and [status] in (1,2)	
				order by RequestedTime desc;
			if(@apmNo =0)
			 begin
				select top 1 @apmNo =apmno,   @LocationID = locationID,  @VisitType= visitType,@scheduleDate= ApmDate, @ScheduleTime = ApmTime,@InmateID=InmateID, @InmateName= InmateName,@ContactPhone= EndUserID,@VisitorID = VisitorID
				From tblVisitEnduserSchedule with(nolock)
				where FacilityID=  @FacilityID and ApmDate= @scheduleDate and  @ScheduleTime= ApmTime and locationID =@LocationID   and [status] in (1,2)	
				order by RequestedTime desc;
			 end
			Else 
			 begin
				SET @CancelReason = 'Inmate Moved';
			 end

		 end
		Else 
		 Begin
			select top 1 @apmNo =apmno,   @LocationID = locationID,  @VisitType= visitType,@scheduleDate= ApmDate, @ScheduleTime = ApmTime, @InmateID=InmateID, @InmateName= InmateName,@ContactPhone= EndUserID,  @VisitorID = VisitorID
			From tblVisitEnduserSchedule with(nolock)
			where FacilityID=  @FacilityID and ApmDate= @scheduleDate and  @ScheduleTime= ApmTime and [status] in (1,2)	order by RequestedTime desc;
		 End
	 end
	Else
	 begin
		SET @apmNo =dbo.fn_check_conflick_schedule_by_location(); 
		if(@apmNo >0)
		 begin
			  SET @CancelReason = 'Inmate Moved';   
			  select  @facilityID = facilityID,   @LocationID = locationID,  @VisitType= visitType,@scheduleDate= ApmDate, @ScheduleTime = ApmTime,@InmateID=InmateID, @InmateName= InmateName,@ContactPhone= EndUserID,@VisitorID = VisitorID
				From tblVisitEnduserSchedule with(nolock) where apmno = @apmNo;
		 end
		else
		 begin
			SET @apmNo =dbo.fn_check_conflick_schedule_by_visitor_area();
			if(@apmNo >0)
			 begin
				  select @facilityID = facilityID,    @LocationID = locationID,  @VisitType= visitType,@scheduleDate= ApmDate, @ScheduleTime = ApmTime,@InmateID=InmateID, @InmateName= InmateName,@ContactPhone= EndUserID,@VisitorID = VisitorID
					From tblVisitEnduserSchedule with(nolock) where apmno = @apmNo;
			 end
		 end

	 end

	 If(@apmNo > 0)			
	  begin
			Update tblVisitEnduserSchedule set status = 4, CancelDate = getdate(), CancelBy = 'Auto', Note =@CancelReason where ApmNo = @apmNo;
			select @FacilityName  = [location], @AgentID=AgentID from tblFacility with(nolock) where FacilityID = @FacilityID ; 
			select @Email = email   from tblEndusers with(nolock) where UserName = @ContactPhone;
			select @VisitorName = Isnull(Vfirstname,'')  + ' ' + isnull(VLastName,'') from tblvisitors with(nolock) where visitorID = @visitorID;
			select  @ContactEmail = ISNULL(ContactEmail,'') , @ContactEmail2= ISNULL(ContactEmail2,''),@ContactEmail3 = ISNULL(ContactEmail3,'') from tblVisitFacilityConfig  with(nolock) where FacilityID=@FacilityId
			If( @ContactEmail <>'')
				SET	@FacilityEmail = @ContactEmail;
			If( @ContactEmail2 <>'')
				SET	@FacilityEmail = 	@FacilityEmail + ';' +  @ContactEmail2;
			If( @ContactEmail3 <>'')
				SET	@FacilityEmail = 	@FacilityEmail + ';' +  @ContactEmail3;
			Select  @iCONurl = isnull(IconURL,@iCONurl) from tblAgent with(nolock) where AgentID = @AgentID;
	  End

	 Select  @apmNo as apmno,   @FacilityName  as FacilityName  ,  @VisitType as visitType,  Convert(varchar(10), @scheduleDate,101) as ApmDate,
		right('0' + ltrim(right(convert(varchar,  cast(@ScheduleTime as dateTime), 100), 7)), 7)   as ApmTime, 
		@InmateID as InmateID, @InmateName as InmateName,@ContactPhone as EndUserID, @Email as ContactEmail, @VisitorName as VisitorName, @FacilityEmail as FacilityEmail,  @CancelReason as CancelReason,
		@iCONurl as iCONurl ;
END
