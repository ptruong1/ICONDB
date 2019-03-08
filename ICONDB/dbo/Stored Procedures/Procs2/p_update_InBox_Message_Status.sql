
CREATE PROCEDURE [dbo].[p_update_InBox_Message_Status]
(
	@MailBoxID int,
	@MessageID int,
	@Status int
)
AS
	SET NOCOUNT OFF;

     Update tblMailboxDetail
      Set 
               
           [MessageStatus] = @Status
           
           where MailBoxID = @MailBoxID and 
                 MessageID = @MessageID ;
      
