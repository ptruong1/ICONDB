-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_appointment_processing_old]
@ApmNo int,
@AccountNo varchar(12),
@facilityID int,
@TotalCharge Numeric(5,2),
@paymentTypeID tinyint,   --1 CreditCard, 7 prepaid Account
@ccNo       VARCHAR(16), 
@ccExp      VARCHAR(4),
@ccCVV      VARCHAR(4)  ,
@BilltoFirstName  VARCHAR(20) , 
@BillToLastName   VARCHAR(20),  
@BillToEmail      varchar(30),
@BillToAddress    varchar(50),
@BillToCity varchar(24),
@BillToZip        VARCHAR(5), 
@BillToState      varchar(2),
@BillToCountry    varchar(30),
@authorizationCode      varchar(7),
@ScheduleStatus tinyint OUTPUT -- 1 processing, 2 approved 
AS
BEGIN
Declare @currentApm smallint, @scheduleDate smalldatetime,@ScheduleTime time(0), @NumOfStations smallint, @locationID int, @iCallSp int, @ApprovedApm bit, @visitorID int, @ApprovedBy varchar(10);
SET @ScheduleStatus =2;
SET @currentApm =0;
SET @ApprovedApm =0;
select @ScheduleStatus= isnull(VisitApmApprovedReq,1)  from  tblVisitFacilityConfig with(nolock)  where FacilityID = @facilityID ;

if(@ScheduleStatus =0) SET @ScheduleStatus=2 ;

select @scheduleDate =ApmDate,@ScheduleTime=ApmTime,@locationID=locationID, @visitorID = VisitorID from [leg_Icon].[dbo].[tblVisitEnduserScheduleTemp] with(nolock) where ApmNo= @ApmNo;

select @ApprovedApm = isnull(ApprovedApm,0) from tblvisitors  with(nolock) where VisitorID = @visitorID;

if(@ApprovedApm =1)  SET @ScheduleStatus=2 ;

If (@ScheduleStatus=2)  SET @ApprovedBy  = 'Auto';

if(@locationID>0)
	SELECT @NumOfStations=  count(*) FROM [tblVisitPhone] with(nolock) where FacilityID =@facilityID and LocationID =@locationID	;
else
	SELECT @NumOfStations=  count(*) FROM [tblVisitPhone]with(nolock)  where FacilityID =@facilityID;
	
if(@paymentTypeID = 7)
 begin
	 EXEC @iCallSp= leg_Icon.dbo.[p_payment_visit_schedule]
					@AccountNo  ,
					@ApmNo         ,
					@facilityID ,
					@TotalCharge   ,
					@paymentTypeID   ,
					@ccNo       ,
					@ccExp     ,
					@ccCVV     ,
					@BilltoFirstName  ,
					@BillToLastName  ,
					@BillToEmail      ,
					@BillToAddress    ,
					@BillToCity ,
					@BillToZip        ,
					@BillToState     ,
					@BillToCountry    ,
					@authorizationCode ;   													 
 end
if(@iCallSp=0)
 Begin
 
					
	 select @currentApm= COUNT(*) from [tblVisitEnduserSchedule] with(nolock)
			where FacilityID = @facilityID and
				  ApmDate  = @scheduleDate and 
				  ApmTime  = @ScheduleTime and				 
				  [status] < 3 ;
	if(	@currentApm <@NumOfStations)
	 begin
		Insert INTO [tblVisitEnduserSchedule] 
			(roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,RequestBy, ApprovedTime  ,   ApprovedBy,
			ApmTime, LimitTime,[status], 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,TotalCharge,Relationship ,locationID, CreatedBy )
		SELECT roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,1,GETDATE(),@ApprovedBy,
			ApmTime, LimitTime,@ScheduleStatus, 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,@TotalCharge,Relationship ,locationID, @AccountNo 
			from tblVisitEnduserScheduleTemp with(nolock) where ApmNo = @ApmNo ; 
			delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo ;
		return 0;
	 end
	else
	 begin
		 delete tblVisitEnduserScheduleTemp where ApmNo = @ApmNo ;
		 SET @totalCharge = - @totalCharge ;
		 EXEC @iCallSp= leg_Icon.dbo.[p_payment_visit_schedule]
					@AccountNo  ,
					@ApmNo         ,
					@facilityID ,
					@TotalCharge   ,
					@paymentTypeID   ,
					@ccNo       ,
					@ccExp     ,
					@ccCVV     ,
					@BilltoFirstName  ,
					@BillToLastName  ,
					@BillToEmail      ,
					@BillToAddress    ,
					@BillToCity ,
					@BillToZip        ,
					@BillToState     ,
					@BillToCountry    ,
					@authorizationCode    	;	
		 return -1;
	 end 
	
 end 
			
END

