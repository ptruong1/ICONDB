-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_visit_appointment_processing]
@ApmNo int,
@AccountNo varchar(12),
@facilityID int,
@TotalCharge Numeric(5,2),
@paymentTypeID tinyint   --1 CreditCard, 7 prepaid Account

AS
BEGIN
Declare @currentApm smallint, @scheduleDate smalldatetime,@ScheduleTime time(0), @NumOfStations smallint,
	@locationID int, @iCallSp int, @ScheduleStatus tinyint, @FacilityContactPhone varchar(10), @FacilityContactEmail varchar(50);
SET @ScheduleStatus =2;
SET @currentApm =0;
SET @iCallSp =0;
select @ScheduleStatus= isnull(VisitApmApprovedReq,1)  from  tblVisitFacilityConfig  where FacilityID = @facilityID ;
select @FacilityContactPhone = contactphone, @FacilityContactEmail = ContactEmail from leg_Icon.dbo.tblfacility where FacilityID = @facilityID ;
if(@ScheduleStatus =0) SET @ScheduleStatus=2
select @scheduleDate =ApmDate,@ScheduleTime=ApmTime,@locationID=locationID from [leg_Icon].[dbo].[tblVisitEnduserSchedule] with(nolock)
		where ApmNo= @ApmNo;
if(@locationID>0)
	SELECT @NumOfStations=  count(*) FROM [tblVisitPhone] with(nolock) where FacilityID =@facilityID and LocationID =@locationID;	
else
	SELECT @NumOfStations=  count(*) FROM [tblVisitPhone]with(nolock)  where FacilityID =@facilityID;
	
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
 Begin
 
					
	 select @currentApm= COUNT(*) from [leg_Icon].[dbo].[tblVisitEnduserSchedule] with(nolock)
			where FacilityID = @facilityID and
				  ApmDate  = @scheduleDate and 
				  ApmTime  = @ScheduleTime and				 
				  [status] < 3;
	if(	@currentApm <@NumOfStations)
	 begin
		Insert INTO [tblVisitEnduserSchedule] 
			(roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,RequestBy, ApprovedTime  ,   ApprovedBy,
			ApmTime, LimitTime,[status], 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,TotalCharge,Relationship ,locationID )
		SELECT roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,1,GETDATE(),'Admin',
			ApmTime, LimitTime,@ScheduleStatus, 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,@TotalCharge,Relationship,locationID  
			from tblVisitEnduserScheduleTemp with(nolock) where ApmNo = @ApmNo;
		delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo;
		Select @ScheduleStatus as ScheduleStatus,  @FacilityContactPhone as FacilityContactPhone , @FacilityContactEmail  as	 FacilityContactEmail;		

		return 0;
	 end
	else
	 begin
		 delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo;
		 SET @totalCharge = - @totalCharge;
		 EXEC @iCallSp= leg_Icon.dbo.[p_payment_visit_schedule]
					@AccountNo  ,					@ApmNo         ,					@facilityID ,					@TotalCharge   ,
					@paymentTypeID   ,					''       ,					''     ,					''     ,
					''  ,					''  ,					''      ,					''    ,
					'' ,					''        ,					''    ,				''    ,					'';    		
		 return -1;
	 end 
	
 end 
Select @ScheduleStatus as ScheduleStatus,  @FacilityContactPhone as FacilityContactPhone , @FacilityContactEmail  as	 FacilityContactEmail		;
END




