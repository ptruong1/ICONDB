-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_video_visit_status] 
	@ConfirmID varchar(12),
	@status tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    update leg_Icon.dbo.tblVisitEnduserSchedule set [status] = @status where ApmNo=@ConfirmID and status = 1;
END

