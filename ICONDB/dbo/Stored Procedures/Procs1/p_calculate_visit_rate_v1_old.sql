-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Modified by Kevin Pham
-- =============================================
CREATE PROCEDURE [dbo].[p_calculate_visit_rate_v1_old]   --- Need Schedule Date
@FacilityID int , 
@InmateID varchar(12) , 
@visitTypeID tinyint, 
@VisitorID int,
@LimitTime int,
@ScheduleDate Datetime,
@TotalCharge  smallmoney OUTPUT

AS
BEGIN
	Declare  @RateQuota smallint, @RelationshipID tinyint, @promo numeric(4,2);
	SET @totalCharge =0;
	SET @RateQuota =0;
	SET @RelationshipID =1;
	SET  @promo =1;
	Select @RelationshipID =RelationshipID  from [leg_Icon].[dbo].tblVisitors with(nolock) where VisitorID =@VisitorID;

	select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime , @RateQuota = isnull(RateQuotaPerMonth,0) from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=@facilityID  and visitType=@visitTypeID;

	if(@totalCharge =0)
		select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime  from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=1 and visitType=@visitTypeID;
    
	if(@RateQuota <> 0 and @RelationshipID not in (0,7,8,9,10) )
	 Begin
		Declare @VisitOnsiteThisMonth smallint;
		SET @VisitOnsiteThisMonth =0;
	
		select @VisitOnsiteThisMonth = count(*) from tblVisitEnduserSchedule with(nolock) 
			   where facilityID = @facilityID and 
					InmateID = @InmateID and visitType =1 and 
				    datepart(MONTH, ApmDate)  = datepart(MONTH, @ScheduleDate)  and
					datepart(Year, ApmDate)  = datepart(Year, @ScheduleDate)  and
					status in (1,2,5) ;
		
		
		
		if(@VisitOnsiteThisMonth >= @RateQuota)
		 begin
				select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime  from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=@facilityID and VisitType= 2;
		 	
		 end
	 End

    --- New Edit promotion for date range
    select @promo =  DiscountPercent from tblPromotion with(nolock) where FacilityID =@FacilityID and (@ScheduleDate between StartDate and EndDate) and PromoteCode='Discount';
	--Select  @totalCharge;
	SET @totalCharge= @totalCharge* @promo;
	 
End	
