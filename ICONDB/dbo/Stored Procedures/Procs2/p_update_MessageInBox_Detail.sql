-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_MessageInBox_Detail] 

	@MessageTypeID int, --1=Voice 2=Email 3=Text, 4=Video
	@MailBoxID int,
	@MessageID int,
	@ReviewNote varchar(150),
	@status tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    UPDATE [leg_Icon].[dbo].[tblMailboxDetail]
   SET 
      [MessageStatus] = @Status
      ,[ReviewNote] = @ReviewNote
 WHERE
	MessageTypeID = @MessageTypeID and 
	MailBoxID = @MailBoxID and
	MessageID = @MessageID;
END

