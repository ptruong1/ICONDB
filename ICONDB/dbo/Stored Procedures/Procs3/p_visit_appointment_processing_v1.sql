-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_visit_appointment_processing_v1]
@ApmNo int,
@AccountNo varchar(12),
@facilityID int,
@TotalCharge Numeric(5,2),
@paymentTypeID tinyint ,  --1 CreditCard, 7 prepaid Account
@PromoteCode varchar(15)

AS
BEGIN
Declare @currentApm smallint, @scheduleDate smalldatetime,@ScheduleTime time(0), @NumOfStations smallint,  @ApprovedApm bit, @visitorID int, @RecordOpt varchar(1), @currentApmAtloc smallint, 
	@locationID int, @iCallSp int, @ScheduleStatus tinyint, @FacilityContactPhone varchar(10), @FacilityContactEmail varchar(50), @ApprovedBy varchar(10) ,@visitType tinyint, @limitTime int ;
Declare @visitLocationID int, @InmateID varchar(12);  
SET @ScheduleStatus =2;
SET @currentApm =0;
SET @iCallSp =0;
SET @ApprovedApm =0;
SET  @RecordOpt  ='Y';
SET @ApprovedBy ='';
SET @currentApmAtloc =0;
SET @limitTime =15;
select @ScheduleStatus= isnull(VisitApmApprovedReq,1)  from  tblVisitFacilityConfig with(nolock)  where FacilityID = @facilityID ;
--select @FacilityContactPhone = contactphone, @FacilityContactEmail = ContactEmail from leg_Icon.dbo.tblfacility with(nolock) where FacilityID = @facilityID ;
SET @FacilityContactPhone= '8887294326';
SET @FacilityContactEmail = 'no-reply@legacyinmate.com';
if(@ScheduleStatus =0) 
	SET @ScheduleStatus=2;
else
	SET @ScheduleStatus=1;

If (@ScheduleStatus =2) SET @ApprovedBy='Auto';

select @scheduleDate =ApmDate,@ScheduleTime=ApmTime,@locationID=locationID, @visitorID =VisitorID, @visitType = visitType,@limitTime =LimitTime  from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] with(nolock)
		where ApmNo= @ApmNo;


select @ApprovedApm = isnull(ApprovedApm,0), @RecordOpt = isnull(RecordOpt,'Y') from tblvisitors  with(nolock) where VisitorID = @visitorID;

if(@ApprovedApm =1)  SET @ScheduleStatus=2 ;
/*
if(@locationID>0)
	SELECT @NumOfStations = [dbo].[fn_get_number_station] (	@FacilityID,@locationID ,''   ,	@visitType) ;
else
	SELECT @NumOfStations=  count(*) FROM [tblVisitPhone]with(nolock)  where FacilityID =@facilityID and status=1 and StationType = @visitType;
If (@visitType =1)
 begin
	select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] with(nolock)
			where FacilityID = @facilityID and   ApmDate  = @scheduleDate and    ApmTime  = @ScheduleTime and  [status] < 3;
	

 end
else
 begin
	select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] with(nolock)
			where FacilityID = @facilityID and   ApmDate  = @scheduleDate and locationID = @locationID and   ApmTime  = @ScheduleTime and  [status] < 3;
 end 
*/

select @NumOfStations = [dbo].[fn_check_avail_by_schedule_time_with_dur] (	@facilityID,	@scheduleDate ,	@locationID ,	@ScheduleTime ,	@visitType,@limitTime);
select @inmateID = InmateID from tblVisitEnduserScheduleTemp where ApmNo = @ApmNo;
SET @visitLocationID = [dbo].[fn_get_onsite_visiting_location_by_inmate](@facilityID ,@inmateID);	

if(	@NumOfStations >0)
	 begin
		if(@paymentTypeID = 7)
		 begin
			 EXEC @iCallSp= leg_Icon.dbo.[p_payment_visit_schedule]
							@AccountNo  ,					@ApmNo         ,					@facilityID ,
							@TotalCharge   ,					@paymentTypeID   ,					''       ,
							''     ,					''     ,					''  ,					''  ,
							''      ,					''    ,					'' ,					''        ,
							''     ,					''    ,					'';    													 
		 end
		if(@iCallSp=0)
		 begin
			Insert INTO [tblVisitEnduserSchedule] 
				(roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,RequestBy, ApprovedTime  ,   ApprovedBy, CreatedBy,
				ApmTime, LimitTime,[status], 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,TotalCharge,Relationship ,locationID, RecordOpt, visitLocationID  )
			SELECT roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,1,GETDATE(), @ApprovedBy, @AccountNo,
				ApmTime, LimitTime,@ScheduleStatus, 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,@TotalCharge,Relationship,locationID  , @RecordOpt, @visitLocationID 
				from tblVisitEnduserScheduleTemp with(nolock) where ApmNo = @ApmNo;
			delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo;
			if ((@PromoteCode <> '' and @PromoteCode is not null) and (select count(*) from tblPromotion where PromoteCode = @PromoteCode) >0)
			 begin
				insert tblPromotionUsed(AccountNo,PromoteCodeUsed,UsedDate) values( @AccountNo, @PromoteCode, getdate());
			 end

			if(@@ERROR =0) 
				Select @ScheduleStatus as ScheduleStatus,  @FacilityContactPhone as FacilityContactPhone , @FacilityContactEmail  as	 FacilityContactEmail;		
			else
				Select 0 as ScheduleStatus,  @FacilityContactPhone as FacilityContactPhone , @FacilityContactEmail  as	 FacilityContactEmail;	
			return 0;
		 end
		Else
		 begin
			delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo;	
			Select null as ScheduleStatus,  @FacilityContactPhone as FacilityContactPhone , @FacilityContactEmail  as	 FacilityContactEmail;		 
			return -1;
		 end
	 end
Else
 begin
	delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo;	
	Select null as ScheduleStatus,  @FacilityContactPhone as FacilityContactPhone , @FacilityContactEmail  as	 FacilityContactEmail;		 
	return -1;
 end

END




