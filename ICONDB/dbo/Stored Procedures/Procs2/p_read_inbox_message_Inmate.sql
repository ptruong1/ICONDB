-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_read_inbox_message_Inmate]
@MailBoxID bigint,
@MessageID bigint
AS
BEGIN
	SET NOCOUNT ON;
	update tblMailboxDetail set IsNew = 0 where MailBoxID =@MailBoxID and  MessageID = @MessageID ;
	select MessageName , Message   from tblMailboxDetail with(nolock) where MailBoxID =@MailBoxID and  MessageID = @MessageID;
	return @@error;
END

