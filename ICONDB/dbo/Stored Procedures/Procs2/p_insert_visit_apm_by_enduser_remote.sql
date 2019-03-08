-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_visit_apm_by_enduser_remote]
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
@RelationShip	varchar(30),
@ApmNo		int OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	
	declare @currentDate as datetime, @ApprovedTime datetime,@ApprovedBy varchar(25),@RoomID int,@CreatedBy varchar(12)
    declare @RequestedTime datetime, @timeZone tinyint, @recordOpt char(1)
    set  @currentDate=GETDATE()
    SET   @timeZone=0
    SET @recordOpt ='Y'
    select @timeZone = isnull(timezone,0) from tblfacility where FacilityID =@FacilityID
    select  @recordOpt = recordOpt from tblVisitors where VisitorID =@VisitorID
    set @RequestedTime =DATEADD (hh,@timeZone, @currentDate) ---- will edit to get local time
    --set @ApmNo= right(CONVERT(varchar(6),@currentDate,12),4)+ LEFT( REPLACE( convert(varchar(15),@currentDate,14),':',''),6)
    
    if(@LocationID =0)
		Select @locationID = locationID from tblVisitInmateConfig where InmateID =@InmateID and FacilityID =@FacilityID  ;
	DECLARE	@return_value int,		@visitConfirmID int

	EXEC	@return_value = [dbo].[p_create_visitConfirmID]
			@visitConfirmID = @visitConfirmID OUTPUT		
	Insert INTO [tblVisitEnduserScheduleTemp] 
	(roomID,apmNo,FacilityID , InmateID , InmateName , 	EndUserID,RequestedTime ,ApmDate ,
	ApmTime, LimitTime,[status], 	visitType,	VisitorID,	AlertCellPhone,		AlertCellCarrier,locationID,RecordOpt,RelationShip,CreatedBy )
	Values
	(@visitConfirmID,@visitConfirmID,@FacilityID , @InmateID ,@InmateName ,@EndUserID ,@RequestedTime,@ApmDate,
	@ApmTime ,@LimitTime,1,@visitType ,@VisitorID,	@AlertCellPhone,@AlertCellCarrier,@locationID,@recordOpt,@RelationShip,@EndUserID )
			             
	SET @ApmNo = @visitConfirmID
END

