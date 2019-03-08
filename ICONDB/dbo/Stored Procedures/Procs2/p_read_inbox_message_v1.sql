CREATE PROCEDURE [dbo].[p_read_inbox_message_v1]
@MailBoxID bigint,
@MessageID bigint
AS
BEGIN
	SET NOCOUNT ON;
	update tblMailboxDetailF set IsNew = 0 where MailBoxID =@MailBoxID and  MessageID = @MessageID ;
	select MessageName , Message, SenderMailBoxID   from tblMailboxDetailF with(nolock) where MailBoxID =@MailBoxID and  MessageID = @MessageID;
	return @@error;
END