-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_mobile_send_message_confirm] 
	@MailBoxID int,
	@MessageFileName	varchar(50),
	@SendStatus tinyint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	update tblMailboxDetail set videostatus =@SendStatus where MailBoxID = @MailBoxID and Message = @MessageFileName ;

	if(@@ERROR =0)
		select 'Success' as Confirm;
	else
		select 'Fail' as Confirm;

END

