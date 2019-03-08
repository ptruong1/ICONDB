-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_video_terminate] 
	@RoomID int,
	@userID varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(RIGHT(@userID,1) ='V')
		update leg_Icon.dbo.tblVisitEnduserSchedule set [status] = 11, CancelBy  = @userID where RoomID =@RoomID and status = 3;
	else 
		update leg_Icon.dbo.tblVisitEnduserSchedule set [status] = 12 ,CancelBy  = @userID  where RoomID=@RoomID and status = 3;
END

select @@ERROR as UpdateChat;

