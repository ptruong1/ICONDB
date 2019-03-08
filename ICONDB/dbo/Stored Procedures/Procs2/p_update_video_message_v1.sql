-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_video_message_v1] 
	@MailboxID	int,
	@MessageID	int,
	@UserID		varchar(15),
	@MessageName	varchar(50) 

AS
BEGIN
	if(right(@UserID,1) = 'I')
		Update tblMailboxDetail set [Message] = @MessageName ,VideoStatus= 2 where MailBoxID = @MailboxID and MessageID= @MessageID;
	else
		Update tblMailboxDetailF set [Message] = @MessageName ,VideoStatus= 2 where MailBoxID = @MailboxID and MessageID= @MessageID;
	--userID will be use to update Family Mail Box
END

