-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_read_sent_message_by_inmate]
@MailBoxID bigint,
@MessageID bigint	
AS
BEGIN
	select MessageName,[Message] 	from tblMailboxDetailF  where MailBoxID =@MailBoxID and MessageID= @MessageID ;
	return @@error;
END

