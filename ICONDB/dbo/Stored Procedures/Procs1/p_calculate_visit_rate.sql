-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Modified by Kevin Pham
-- =============================================
CREATE PROCEDURE [dbo].[p_calculate_visit_rate]
@FacilityID int , 
@InmateID varchar(12) , 
@visitTypeID tinyint, 
@VisitorID int,
@LimitTime int,
@TotalCharge  smallmoney OUTPUT

AS
BEGIN
	Declare  @RateQuota tinyint, @RelationshipID tinyint;
	SET @totalCharge =0;
	SET @RateQuota =0;
	
	Select @RelationshipID =RelationshipID  from [leg_Icon].[dbo].tblVisitors with(nolock) where VisitorID =@VisitorID;
	select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime , @RateQuota = isnull(RateQuotaPerMonth,0) from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=@facilityID  and visitType=@visitTypeID;

	if(@totalCharge =0)
		select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime  from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=1 and visitType=@visitTypeID;
    
	if(@RateQuota > 0 and @RelationshipID not in (0,8) )
	 Begin
		Declare @VisitOnsiteThisMonth smallint;
		SET @VisitOnsiteThisMonth =0;
	
		select @VisitOnsiteThisMonth = count(*) from tblVisitEnduserSchedule with(nolock) 
			   where facilityID = @facilityID and 
					InmateID = @InmateID and visitType =1 and 
				    datepart(MONTH, ApmDate)  = datepart(MONTH, getdate())  and
					datepart(Year, ApmDate)  = datepart(Year, getdate())  and
					status in (1,2,5) and
					visitorID not in (select visitorID from tblvisitors with(nolock) where facilityID = @facilityID and RelationshipID in(0,8));
		if(@VisitOnsiteThisMonth >= @RateQuota)
				   select  @totalCharge= ConnectFee + PerMinCharge *@LimitTime  from [leg_Icon].[dbo].[tblVisitRate] with(nolock) where RateID=@facilityID and VisitType= 2;
		 		
		
	 End

End	
