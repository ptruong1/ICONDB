-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_SentItem_Message_status] 
	@MailBoxID int,
	@MessageID int,
	@status tinyint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    UPDATE [leg_Icon].[dbo].[tblMailboxDetailF]
   SET 
      [MessageStatus] = @Status
      
 WHERE 
	MailBoxID = @MailBoxID and
	MessageID = @MessageID 
END

