-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_visit_apm_by_enduser_Remote_11212016]
@FacilityID int , 
@RoomID int,
@ApprovedTime datetime,
@ApprovedBy varchar(25),
@ApmDate   varchar(12),  
@ApmTime  varchar(12),
@Status tinyint,
@LimitTime int,
@StationID varchar(25),
@InmateLogInID varchar(25),
@VisitorLogInID varchar(25),
@Note varchar(100),
@RecordOpt varchar(1),
@CancelBy varchar(25)

AS
BEGIN

	SET NOCOUNT ON; 
	
	Update tblVisitEnduserSchedule 
	Set
	
	ApprovedTime = @ApprovedTime
	,ApprovedBy = @ApprovedBy
    ,ApmDate = CONVERT(datetime,@ApmDate ,110)
    ,ApmTime = Convert(time, Left(@ApmTime,Len(@ApmTime)-3), 114) 
    ,LimitTime = @LimitTime
    ,[status] = @status 
    ,StationID = @StationID
    ,InmateLogInID = @InmateLogInID
    ,VisitorLogInID = @VisitorLogInID
    ,Note = @Note
    ,RecordOpt = @RecordOpt
    ,CancelBy = @CancelBy
    ,CancelDate = GETDATE()
    
	where FacilityID = @FacilityID and
	      RoomID = @RoomID;

END

