-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_video_visit_status_Visitor] 
	@ConfirmID varchar(12),
	@status tinyint,
	@VisitorIP varchar(16)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    update leg_Icon.dbo.tblVisitEnduserSchedule set [status] = @status, VisitorLogInID=@VisitorIP where ApmNo=@ConfirmID;
END

