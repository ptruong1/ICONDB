-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_complete_video_visit]
@ConfirmNo  varchar(15) OUTPUT,
@ServerIP   varchar(20) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @facility int , @ServerTime datetime;
	SET @ConfirmNo ='';
	SET @ServerIP ='';

	-- SELECT top 1 @ConfirmNo = RoomID, @ServerIP = ChatServerIP from tblVisitOnline with(nolock) where  status =5 ;
	
	SET @ServerTime = GETDATE();
	SELECT top 1 @ConfirmNo = RoomID, @ServerIP = ChatServerIP, @facility = FacilityID  from tblVisitEnduserSchedule with(nolock) where  (status =5 or status =9) and (RecordStatus is null) and RecordOpt='Y';--  and  (FacilityID <> 803)  order by RoomID desc ;
	
	if(@ConfirmNo='')
	 begin
		SELECT top 1 @ConfirmNo = v.RoomID, @ServerIP = v.ChatServerIP, @facility = f.FacilityID 
		from tblVisitEnduserSchedule v with(nolock),tblfacility f with(nolock)
		where 	f.FacilityID = v.FacilityID and
		DATEADD(MINUTE,limittime + 60,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @ServerTime) and v.[status] in (1,2,3) and v.RecordStatus is null and  v.RecordOpt='Y' ;--  order by RoomID desc  ;
	 end
	if(@ConfirmNo='')
	 begin
		SELECT top 1 @ConfirmNo = v.RoomID, @ServerIP = v.ChatServerIP, @facility = f.FacilityID 
		from tblVisitEnduserSchedule v with(nolock),tblfacility f with(nolock)
		where 	f.FacilityID = v.FacilityID and
		DATEADD(MINUTE,limittime + 120,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @ServerTime) and v.[status] in (1,2,3) and v.RecordStatus is null and  v.RecordOpt='Y' ;--  order by RoomID desc  ;
	 end
	if(@ConfirmNo <> '')
	 begin
		
		if(@ServerIP is null)
			select @ServerIP  = ChatServerIP  from  tblVisitPhoneServer with(nolock) where FacilityID = @facility ;-- and (FacilityID <> 803);
		--Update tblVisitOnline set status =0  where  status =5 and RoomID= @ConfirmNo;
		update tblVisitEnduserSchedule set RecordStatus =0  where   RoomID= @ConfirmNo;
		if(@ServerIP='v1.legacyinmate.com' or @ServerIP='207.141.247.182' )
			SET @ServerIP = '172.77.10.11' ;
		else
			SET @ServerIP = '172.77.10.12' ;

	 end 
  
	 Update tblVisitEnduserSchedule set status =5, VisitDuration = v.VisitDuration
		 from tblVisitEnduserSchedule v with(nolock),tblfacility f with(nolock), tblVisitOnline O with(nolock) 
		 where 	f.FacilityID = v.FacilityID and O.FacilityID = f.FacilityID and O.RoomID = v.RoomID and O.InmateLoginTime is not null and O.VisitorLoginTime is not null and
		 DATEADD(MINUTE,v.limittime + 60,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @ServerTime) and v.[status] =3 and v.RecordOpt='N' ;--  order by RoomID desc  ;
	
	 Update tblVisitEnduserSchedule set status =7
		  from tblVisitEnduserSchedule v with(nolock),tblfacility f with(nolock), tblVisitOnline O with(nolock) 
		 where 	f.FacilityID = v.FacilityID and O.FacilityID = f.FacilityID and O.RoomID = v.RoomID and (O.InmateLoginTime is  null and O.VisitorLoginTime is not null) and
		 DATEADD(MINUTE,v.limittime + 60,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @ServerTime) and (v.[status] in (2,3)) and v.RecordOpt='N';

     	
	 Update tblVisitEnduserSchedule set status =8
		  from tblVisitEnduserSchedule v with(nolock),tblfacility f with(nolock), tblVisitOnline O with(nolock) 
		 where 	f.FacilityID = v.FacilityID and O.FacilityID = f.FacilityID and O.RoomID = v.RoomID and (O.InmateLoginTime is not  null and O.VisitorLoginTime is null) and
		 DATEADD(MINUTE,v.limittime + 60,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @ServerTime) and (v.[status] in (2,3)) and v.RecordOpt='N';

      Update tblVisitEnduserSchedule set status =10
		  from tblVisitEnduserSchedule v with(nolock),tblfacility f with(nolock), tblVisitOnline O with(nolock) 
		 where 	f.FacilityID = v.FacilityID and O.FacilityID = f.FacilityID and O.RoomID = v.RoomID and (O.InmateLoginTime is  null and O.VisitorLoginTime is null) and
		 DATEADD(MINUTE,v.limittime + 60,DATEADD(MINUTE,DATEPART(MINUTE,v.ApmTime),  DATEADD(HOUR,DATEPART(HOUR,v.ApmTime), v.ApmDate ))) < DATEADD(HOUR, f.timeZone , @ServerTime) and (v.[status] in (2,3)) and v.RecordOpt='N';

END

