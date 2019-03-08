-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_inmate_visitor_schedule_test]
	@PublicIP varchar(15),
	@PIN varchar(12)
AS
BEGIN
	Declare @facilityID int, @InmateID varchar(12),@flatform tinyint, @localTime datetime,@timezone tinyint,@LocationID int, @InmateLocationID int;
	SET @facilityID =0;
	SET  @InmateID ='';
	SET @timeZone = 0;
	Select @facilityID = facilityID,@LocationID = LocationID  from  leg_Icon.dbo.tblVisitPhone with(nolock)  where ExtID =@PublicIP;
	if( @facilityID =0)
		Select @facilityID = facilityID from  leg_Icon.dbo.tblVisitLocation with(nolock)  where LocationName =@PublicIP;
	
    select @InmateID = InmateID  from tblInmate with(nolock) where FacilityId =@facilityID and PIN =@PIN and status=1; 	

	if(	@InmateID ='')
		return 0;
	--Update tblVisitInmateConfig set LocationID = @LocationID where FacilityID = @FacilityID and InmateID = @inmateID ;			  

	--- New Edit on 8/8/2016
	Select @InmateLocationID = isnull(locationID,0) from  tblVisitInmateConfig with(nolock) where FacilityID=@facilityID and InmateID=@InmateID;

	select @InmateLocationID as InmateLocationID, @LocationID as KiokLocation
	--If( @InmateLocationID  > 0 and ( @InmateLocationID  <> @LocationID))
	--	return 0;
	--Else If (@InmateLocationID  = 0 and  @LocationID >0)
	--	Update tblVisitInmateConfig set LocationID = @LocationID, ModifyDate =GETDATE()  where FacilityID = @FacilityID and InmateID = @inmateID ;
    
	 if(@FacilityID >0 and @InmateLocationID is null and @InmateID <> '0')	
		insert tblVisitInmateConfig(InmateID ,FacilityID ,LocationID ,InputDate)
								   values(@inmateID , @facilityID ,@LocationID ,GETDATE())
					 
	--- End U new update  
	/*
	if (select COUNT(*) from tblVisitInmateConfig with(nolock) where FacilityID = @FacilityID and InmateID = @inmateID) >0
		Update tblVisitInmateConfig set LocationID = @LocationID, ModifyDate =GETDATE()  where FacilityID = @FacilityID and InmateID = @inmateID ;
	else
	 if(@FacilityID >0 and @InmateID > 0 )	
		insert tblVisitInmateConfig(InmateID ,FacilityID ,LocationID ,InputDate)
								   values(@inmateID , @facilityID ,@LocationID ,GETDATE())
					 
	-------------------------------------------------------------	
	*/
	Select @timeZone = timeZone,@flatform =flatform from tblFacility with(nolock) where facilityID =@facilityID;
	SET @localTime = DATEADD (HOUR,@timeZone,GETDATE());
	---Hardcode for Fresno
	if(@facilityID =352)
		return 0;
	
	select @facilityID, @localTime,@InmateID, 'TEST'
	if(@facilityID>0)
	 begin
		select t1.InmateName,(t2.VFirstName + ' ' + t2.VLastName) as VisitorName,Convert(varchar(10),t1.ApmDate ,101) as AptDate,
		CONVERT(varchar(10), ApmTime,100) ApmTime, t3.Descript visitType ,t1.InmateID , t1.RoomID --,DATEADD(MINUTE,DATEPART(MINUTE,t1.ApmTime), dateAdd(HOUR,DATEPART(hour,t1.ApmTime),t1.ApmDate)) 
		from leg_Icon.dbo.tblVisitEnduserSchedule  t1 with(nolock)  Inner join leg_Icon.dbo.tblVisitors t2 with(nolock) On  (t1.FacilityID = t2.FacilityID and t1.VisitorID = t2.VisitorID )
		Inner join leg_Icon.dbo.tblVisitType t3 with(nolock) ON t1.visitType = t3.VisitTypeID
		where 
			  t1.FacilityID =@facilityID
			  and t1.InmateID = @InmateID
			  and t1.status in (2,3)
			  and DATEADD(MINUTE,t1.LimitTime , DATEADD(MINUTE,DATEPART(MINUTE,t1.ApmTime), dateAdd(HOUR,DATEPART(hour,t1.ApmTime),t1.ApmDate))) > @localTime 
			  order by  ApmDate, ApmTime ASC;
	 end
	else
		--print 'test'
		select t1.InmateName,(t2.VFirstName + ' ' + t2.VLastName) as VisitorName,Convert(varchar(10),t1.ApmDate ,101) as AptDate,
		CONVERT(varchar(10), ApmTime,100) ApmTime, t3.Descript visitType , t1.InmateID , t1.RoomID
		from leg_Icon.dbo.tblVisitEnduserSchedule t1 with(nolock),leg_Icon.dbo.tblVisitors t2 with(nolock),leg_Icon.dbo.tblVisitType t3 with(nolock), tblInmate t4 with(nolock)
		where t1.FacilityID = t2.FacilityID 
			  and t1.VisitorID = t2.VisitorID 
			  and t1.visitType = t3.VisitTypeID 
			  and t1.FacilityID =t4.FacilityId 
			  and t1.InmateID = t4.InmateID
			  and t4.PIN = @InmateID
			  and t1.FacilityID =@facilityID
			  and t1.status in (2,3)
			  and DATEADD(MINUTE,t1.LimitTime , DATEADD(MINUTE,DATEPART(MINUTE,t1.ApmTime), dateAdd(HOUR,DATEPART(hour,t1.ApmTime),t1.ApmDate))) > @localTime 
			  order by  ApmDate, ApmTime ASC;
	
END

