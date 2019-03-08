-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_video_visit_status_04122017] 
	@ConfirmID varchar(12),
	@status tinyint,
	@facilityID int,
	@ApprovedBy varchar(25),
	@UserIP varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 Declare @UserAction varchar(200)
	 Set @UserAction = 'Update Visit status from pending to approve for ConfirmID ' +  @ConfirmID + ' by ' + @ApprovedBy
		EXEC  INSERT_ActivityLogs5   @FacilityID,18, @UserAction, @ApprovedBy, @UserIP
		
    update leg_Icon.dbo.tblVisitEnduserSchedule 
     set [status] = @status, [ApprovedBy] = @ApprovedBy
     where ApmNo=@ConfirmID and status = 1;
END

