-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[p_read_sent_message]
@MailBoxID bigint,
@MessageID bigint	
AS
BEGIN
	select  MessageName , Message 	from tblMailboxDetail  where MailBoxID = @MailBoxID and  MessageID =@MessageID
	
	return @@error;
END
