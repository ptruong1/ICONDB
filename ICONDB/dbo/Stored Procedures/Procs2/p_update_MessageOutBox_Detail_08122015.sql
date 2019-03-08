-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_MessageOutBox_Detail_08122015] 

	@MessageTypeID int, --1=Voice 2=Email 3=Text, 4=Video
	@MailBoxID int,
	@MessageID int,
	@ReviewNote varchar(150),
	@status tinyint,
	@UserName varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @status = 1
	UPDATE [leg_Icon].[dbo].[tblMailboxDetailF]
	   SET 
		  [MessageStatus] = @Status
		  ,[ReviewNote] = @ReviewNote
		  WHERE
			MessageTypeID = @MessageTypeID and 
			MailBoxID = @MailBoxID and
			MessageID = @MessageID
	else
    if @status = 2
		UPDATE [leg_Icon].[dbo].[tblMailboxDetailF]
	   SET 
		  [MessageStatus] = @Status
		  ,[ReviewNote] = @ReviewNote
		  ,[ApprovedBy] = @Username
		  ,[ApprovedDate] = GETDATE()
		  WHERE
			MessageTypeID = @MessageTypeID and 
			MailBoxID = @MailBoxID and
			MessageID = @MessageID
	else
		UPDATE [leg_Icon].[dbo].[tblMailboxDetailF]
		SET
		  [MessageStatus] = @Status
		  ,[ReviewNote] = @ReviewNote
		  ,[DeniedBy] = @Username
		  ,[DeniedDate] = GETDATE()
	WHERE
		MessageTypeID = @MessageTypeID and 
		MailBoxID = @MailBoxID and
		MessageID = @MessageID
 
END

