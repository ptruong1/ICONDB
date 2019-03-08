-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_visit_apm_by_enduser_Remote]
@FacilityID int , 
@RoomID int,
@ApprovedTime datetime,
@ApprovedBy varchar(25),
@ApmDate   Datetime,  
@ApmTime  varchar(5),
@Status tinyint,
@LimitTime int,
@StationID varchar(25),
@InmateLogInID varchar(25),
@VisitorLogInID varchar(25),
@Note varchar(100)

AS
BEGIN

	SET NOCOUNT ON;
	
	Update tblVisitEnduserSchedule 
	Set
	
	ApprovedTime = @ApprovedTime
	,ApprovedBy = @ApprovedBy
    --,ApmDate = @ApmDate 
    --,ApmTime = @ApmTime
    --,LimitTime = @LimitTime
    ,[status] = @status 
    ,StationID = @StationID
    ,InmateLogInID = @InmateLogInID
    ,VisitorLogInID = @VisitorLogInID
    ,Note = @Note
    
	where FacilityID = @FacilityID and
	      RoomID = @RoomID

END

