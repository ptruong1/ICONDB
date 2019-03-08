-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_read_inbox_message]
@MailBoxID bigint,
@MessageID bigint
AS
BEGIN
	SET NOCOUNT ON;
	update tblMailboxDetailF set IsNew = 0 where MailBoxID =@MailBoxID and  MessageID = @MessageID ;
	select MessageName , Message   from tblMailboxDetailF with(nolock) where MailBoxID =@MailBoxID and  MessageID = @MessageID;
	return @@error;
END

