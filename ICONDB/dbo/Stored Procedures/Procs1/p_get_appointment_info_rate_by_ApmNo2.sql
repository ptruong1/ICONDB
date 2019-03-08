-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Modified by Kevin Pham
-- =============================================
CREATE PROCEDURE [dbo].[p_get_appointment_info_rate_by_ApmNo2]
@ApmNo int

AS
BEGIN
	Declare @facilityID int, @VisitorID int, @visitTypeID tinyint,@locationID int, @RateQuota tinyint, @InmateID varchar(12);
	declare @VisistorName varchar(50),
			@InmateName	  varchar(50),
			@ApmDate	 datetime ,
			@ApmTime	 varchar(5) ,
			@VisitType	 Varchar (20) ,
			@LimitTime		int ,
			@totalCharge	smallmoney,
			@AlertCellPhone varchar(10),
			@AlertCellCarrier varchar(25),
			@facilityName varchar(40),
			@LocationName varchar(40),
			@relationShip varchar(20);
			
	SET @totalCharge =0;
	SET @RateQuota =0;
	Select @InmateName=InmateName, @InmateID = InmateID,
			@ApmDate=ApmDate,
			@ApmTime=ApmTime,
			@LimitTime=LimitTime,
			@facilityID=FacilityID, 
			@visitTypeID= visitType,
			@AlertCellPhone =AlertCellPhone,
			@AlertCellCarrier=AlertCellCarrier,
			@locationID=locationID,
			@VisitorID =   VisitorID,
			@relationShip = relationShip
			 from tblVisitEnduserScheduleTemp where apmNo =@ApmNo;
	Select @VisistorName = VFirstName + ' ' + VLastName  from [leg_Icon].[dbo].tblVisitors with(nolock) where VisitorID =@VisitorID;
	
	select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime ,@RateQuota= isnull(RateQuotaPerMonth,0) from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=@facilityID  and visitType=@visitTypeID;
	--select  @RateQuota= isnull(RateQuotaPerMonth,0)  from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=@facilityID  and visitType=1;
	Select @VisitType = Descript  from [leg_Icon].[dbo].tblVisitType with(nolock) where VisitTypeID = @visitTypeID;
	Select @facilityName = location from tblfacility with(nolock) where FacilityID = @facilityID ;  
	Select @LocationName = LocationName from tblVisitLocation where LocationID =@locationID ;
			
	if(@totalCharge =0)
		select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime , @RateQuota= isnull(RateQuotaPerMonth,0) from [leg_Icon].[dbo].[tblVisitRate] where RateID=1 and visitType=@visitTypeID;
	if(@RateQuota > 0)
	 Begin
		Declare @VisitOnsiteThisMonth smallint;
		SET @VisitOnsiteThisMonth =0
		select @VisitOnsiteThisMonth = count(*) from tblVisitEnduserSchedule with(nolock) 
			   where facilityID = @facilityID and 
					InmateID = @InmateID and visitType =1 and 
				    datepart(MONTH, ApmDate)  = datepart(MONTH, getdate())  and
					datepart(Year, ApmDate)  = datepart(Year, getdate())  and
					status in (1,2,5) and
					visitorID not in (select visitorID from tblvisitors where facilityID = @facilityID and RelationshipID in(0,8));
				if(@VisitOnsiteThisMonth > @RateQuota)
				   select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime  from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=@facilityID and VisitType= 2;
					
		
	 End
 
	select  @facilityName as FacilityName,
			@LocationName as LocationName,
			@VisistorName as VisistorName,
			@InmateName	  as InmateName,
			@ApmDate	 as ApmDate ,
			@ApmTime	 as ApmTime ,
			@VisitType	 as VisitType ,
			@visitTypeID as VisitTypeID,
			@LimitTime	 as LimitTime,
			@totalCharge	as TotalCharge,
			@AlertCellPhone as AlertCellPhone,
			@AlertCellCarrier as AlertCellCarrier,
			@relationShip as RelationShip ;
END



