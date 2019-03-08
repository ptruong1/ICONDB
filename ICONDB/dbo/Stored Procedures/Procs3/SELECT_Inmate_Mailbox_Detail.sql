CREATE PROCEDURE [dbo].[SELECT_Inmate_Mailbox_Detail]

@MailBoxID int

AS
	SET NOCOUNT ON;
SELECT     MailBoxID, MessageID, MessengerNo, MessageDate, MessageName, IsNew
FROM         tblMailboxDetail with (nolock) where MailBoxID = @MailboxID
