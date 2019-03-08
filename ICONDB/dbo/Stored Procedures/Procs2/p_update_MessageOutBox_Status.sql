
CREATE PROCEDURE [dbo].[p_update_MessageOutBox_Status]
(
	@MessageTypeID int, --1=Voice 2=Email 3=Text, 4=Video
	@MailBoxID int,
	@MessageID int,
	@Status int
)
AS
	SET NOCOUNT OFF;

     Update tblMailboxDetailF
      Set 
               
           [MessageStatus] = @Status
           
           where 
           MessageTypeID = @MessageTypeID and
           MailBoxID = @MailBoxID and 
                 MessageID = @MessageID 
      
