﻿
CREATE PROCEDURE [dbo].[p_update_MessageOutBox_Status_10262017]
(
	@MailBoxID int,
	@MessageID int,
	@Status int,
	@ApprovedBy varchar(25)
)
AS
	SET NOCOUNT OFF;

     Update tblMailboxDetailF
      Set 
               
           [MessageStatus] = @Status
           ,[ApprovedBy] = @ApprovedBy
			,[ApprovedDate] = GETDATE()
			
           where 
                 MailBoxID = @MailBoxID and 
                 MessageID = @MessageID 
      
