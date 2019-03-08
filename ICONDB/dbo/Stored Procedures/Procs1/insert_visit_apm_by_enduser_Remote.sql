-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insert_visit_apm_by_enduser_Remote]
@FacilityID int , 
@InmateID varchar(12) , 
@InmateName varchar(40),  
@EndUserID varchar(10),
@VisitorName varchar(25), 
@RequestedTime datetime,
@ApprovedTime datetime,
@ApprovedBy varchar(25),
@ApmDate   Datetime,  
@ApmTime  varchar(5),
@CreatedBy  varchar(25) ,  
@visitType tinyint, 
@Status tinyint,
@LimitTime int,
@VisitorID tinyint,
@StationID varchar(25),
@AlertCellPhone varchar(10),
@AlertCellCarrier varchar(25),
@ApmNo		varchar(11) OUTPUT,
@RoomID int OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	declare @currentDate as datetime
    set  @currentDate=GETDATE()
    --set @ApmNo= right(CONVERT(varchar(6),@currentDate,12),4)+ LEFT( REPLACE( convert(varchar(15),@currentDate,14),':',''),6)
	DECLARE	@return_value int,		@visitConfirmID int

	EXEC	@return_value = [dbo].[p_create_visitConfirmID]
			@visitConfirmID = @visitConfirmID OUTPUT	
	Insert INTO [tblVisitEnduserSchedule] 
	(
	RoomID ,
	ApmNo,
	 FacilityID , 
	InmateID , 
	InmateName ,  
	EndUserID,
	RequestedTime , 
	RequestBy ,
	ApprovedTime,
	ApprovedBy,
    ApmDate ,  
    ApmTime, 
    LimitTime,
    [status], 
    CreatedBy ,  
    visitType, 
    
    VisitorID,
    StationID,
    AlertCellPhone,
    AlertCellCarrier)
	Values
	(
	@visitConfirmID,
	@visitConfirmID,
	@FacilityID , 
	@InmateID ,
	@InmateName ,
	@EndUserID ,
	@RequestedTime,
	1,
	@ApprovedTime,
	@ApprovedBy,
	@ApmDate,
	@ApmTime ,
	@LimitTime,
	@Status, 
	@CreatedBy ,
	@visitType ,
	
	@VisitorID,
	@StationID,
	@AlertCellPhone,
    @AlertCellCarrier)
	SET @ApmNo	=	@visitConfirmID
	SET  @RoomID = @visitConfirmID

END

