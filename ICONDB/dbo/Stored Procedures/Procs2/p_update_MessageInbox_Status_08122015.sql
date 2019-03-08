
CREATE PROCEDURE [dbo].[p_update_MessageInbox_Status_08122015]
(
	@MessageTypeID int, --1=Voice 2=Email 3=Text, 4=Video
	@MailBoxID int,
	@MessageID int,
	@Status int,
	@ApprovedBy varchar(25)
)
AS
	SET NOCOUNT OFF;

     Update tblMailboxDetail
      Set 
               
           [MessageStatus] = @Status
           ,[ApprovedBy] = @ApprovedBy
			,[ApprovedDate] = GETDATE()
      
           where 
           MessageTypeID = @MessageTypeID and
           MailBoxID = @MailBoxID and 
                 MessageID = @MessageID ;
      
