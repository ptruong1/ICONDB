-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_billtype_method]
@facilityID int,
@billtype varchar(2),
@toNo varchar(16)

AS
BEGIN
	
	SET NOCOUNT ON;
	Declare @CallsPerDay smallint, @CallsPerweek  smallint, @CallsPerMonth smallint, @CallsPerDayC smallint, @CallsPerweekC  smallint, @CallsPerMonthC smallint;
	SET @CallsPerDay = 0;
	SET @CallsPerweek  = 0; 
	SET @CallsPerMonth  =0;
	SET @CallsPerDayC = 0;
	SET @CallsPerweekC  = 0; 
	SET @CallsPerMonthC  =0
	-- Don't care about @billtype for now
	select @CallsPerDay= CallsPerDay,@CallsPerweek= CallsPerweek,@CallsPerMonth= CallsPerMonth from tblFacilityBillThreshold with(nolock) where FacilityID=@facilityID and BillType=@billtype;
	
	select @CallsPerDayC= CallsPerDay,@CallsPerweekC= CallsPerweek,@CallsPerMonthC= CallsPerMonth from tblFacilityBillThreshold with(nolock) where FacilityID=@facilityID and BillType='05';
	
	--If(@billtype ='01')
	/*
	if(@billtype in ('03','05')) 
	 Begin
		if(@CallsPerDay > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType in ('03','05') and  tono= @toNo and  datediff(day, recorddate, getdate()) =0) >= @CallsPerDay 
				return 2;
		 end
		if(@CallsPerWeek > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and  billType in ('03','05') and  tono= @toNo and   datediff(day, recorddate, getdate()) <=7) >= @CallsPerweek
				return 2;
		 end
		 if(@CallsPerMonth > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType in ('03','05') and  tono= @toNo  and  datediff(day, recorddate, getdate()) <=30)>= @CallsPerMonth
				return 2;
		 end
	 end
	Else
	  Begin
		if(@CallsPerDay > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType = @billtype and  tono= @toNo and  datediff(day, recorddate, getdate()) =0) >= @CallsPerDay 
				return 2;
		 end
		if(@CallsPerWeek > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and  billType = @billtype  and  tono= @toNo and   datediff(day, recorddate, getdate()) <=7) >= @CallsPerweek
				return 2;
		 end
		 if(@CallsPerMonth > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType = @billtype  and  tono= @toNo  and  datediff(day, recorddate, getdate()) <=30)>= @CallsPerMonth
				return 2;
		 end
	 end
	 */
	if(@CallsPerDay > 0   )
		begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType = @billtype and  tono= @toNo and  datediff(day, recorddate, getdate()) =0) >= @CallsPerDay 
			 begin
				if(select count(*) from tblprepaid with(nolock) where 	PhoneNo= @toNo) >0
					return 5;
				return 2;
			 end
			
		end
	if(@CallsPerWeek > 0  )
		begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and  billType = @billtype  and  tono= @toNo and   datediff(day, recorddate, getdate()) <=7) >= @CallsPerweek
			 begin
				if(select count(*) from tblprepaid with(nolock) where 	PhoneNo= @toNo) >0
					return 5;
				return 2;
			 end
			
		end
		if(@CallsPerMonth > 0  )
		begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType = @billtype  and  tono= @toNo  and  datediff(day, recorddate, getdate()) <=30)>= @CallsPerMonth
			 begin
				if(select count(*) from tblprepaid with(nolock) where 	PhoneNo= @toNo) >0
					return 5;
				return 2;
			 end
			
		end
		--- Credit card Check
	    if(@CallsPerDayC > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType in ('03','05') and  tono= @toNo and  datediff(day, recorddate, getdate()) =0) >= @CallsPerDayC 
			begin
				if(select count(*) from tblprepaid with(nolock) where 	PhoneNo= @toNo) >0
					return 5;
				return 2;
			 end
		 end
		if(@CallsPerWeekC > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and  billType in ('03','05')  and  tono= @toNo and   datediff(day, recorddate, getdate()) <=7) >= @CallsPerweekC
			 begin
				if(select count(*) from tblprepaid with(nolock) where 	PhoneNo= @toNo) >0
					return 5;
				return 2;
			 end
		 end
		 if(@CallsPerMonthC > 0)
		 begin
			if (Select count(*) from tblcallsbilled with(nolock) where facilityID = @facilityID and billType in ('03','05')  and  tono= @toNo  and  datediff(day, recorddate, getdate()) <=30)>= @CallsPerMonthC
			 begin
				if(select count(*) from tblprepaid with(nolock) where PhoneNo= @toNo) >0
					return 5;
				return 2;
			 end
		 end
	  
	return 0;

   
END

