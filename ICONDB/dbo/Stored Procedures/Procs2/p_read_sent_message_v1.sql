CREATE  PROCEDURE [dbo].[p_read_sent_message_v1]
@MailBoxID bigint,
@MessageID bigint	
AS
BEGIN
	select  MessageName , Message, SenderMailBoxID 	from tblMailboxDetail  where MailBoxID = @MailBoxID and  MessageID =@MessageID
	
	return @@error;
END
