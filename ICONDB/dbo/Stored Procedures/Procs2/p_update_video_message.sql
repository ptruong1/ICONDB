-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_video_message] 
	@MailboxID	int,
	@MessageID	int,
	@UserID		int,
	@MessageName	varchar(50) 

AS
BEGIN
	Update tblMailboxDetail set MessageName = @MessageName ,MessageStatus= 2 where MailBoxID = @MailboxID and MessageID= @MessageID;
	--userID will be use to update Family Mail Box
END

