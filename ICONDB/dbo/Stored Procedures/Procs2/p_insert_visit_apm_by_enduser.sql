﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_visit_apm_by_enduser]
@FacilityID int , 
@LocationID int,
@InmateID varchar(12) , 
@InmateName varchar(40),  
@EndUserID varchar(12),
@ApmDate   Datetime,  
@ApmTime  varchar(5), 
@visitType tinyint, 
@LimitTime int,
@VisitorID int,
@AlertCellPhone varchar(10),
@AlertCellCarrier varchar(25),
@Relationship varchar(30),
@ApmNo		int OUTPUT,
@TotalCharge  numeric(6,2) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	declare @currentDate as datetime, @ApprovedTime datetime,@ApprovedBy varchar(25),@RoomID int,@CreatedBy varchar(12);
    declare @RequestedTime datetime, @timeZone tinyint, @recordOpt char(1)DECLARE	@return_value int,	@visitConfirmID int , @ApprovedApm bit;
    set  @currentDate=GETDATE();
    SET   @timeZone=0;
    SET @recordOpt ='Y';
	SET  @ApprovedApm  =0;
    select @timeZone = isnull(timezone,0) from tblfacility with(nolock) where FacilityID =@FacilityID;
    select  @recordOpt = isnull(recordOpt,'Y'), @ApprovedApm = isnull(ApprovedApm,0) from tblVisitors with(nolock) where VisitorID =@VisitorID;
    set @RequestedTime =DATEADD (hh,@timeZone, @currentDate) ---- will edit to get local time
    --set @ApmNo= right(CONVERT(varchar(6),@currentDate,12),4)+ LEFT( REPLACE( convert(varchar(15),@currentDate,14),':',''),6)
	if(@LocationID =0)
		Select @locationID = locationID from tblVisitInmateConfig where InmateID =@InmateID and FacilityID =@FacilityID  ;
	SET @TotalCharge = dbo.fn_CalculateVisitChargeAmt  (@facilityID,@visitType,@LimitTime);

	EXEC	@return_value = [dbo].[p_create_visitConfirmID]
			@visitConfirmID = @visitConfirmID OUTPUT	;	
	Insert INTO [tblVisitEnduserScheduleTemp] 
	(roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,
	ApmTime, LimitTime,[status], 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,locationID,RecordOpt,Relationship, CreatedBy )
	Values
	(@visitConfirmID,@visitConfirmID,@FacilityID , @InmateID ,@InmateName ,@EndUserID ,@RequestedTime,@ApmDate,
	@ApmTime ,@LimitTime,1,@visitType ,@VisitorID,	@AlertCellPhone,@AlertCellCarrier,@locationID,@recordOpt,@Relationship,@EndUserID );
			             
	SET @ApmNo = @visitConfirmID;
END

