-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_sent_messages]
@AccountNo varchar(12)	
AS
BEGIN
	Declare @SenderMailboxID as int;
	Select @SenderMailboxID  = mailboxID from tblMailboxF with(nolock) where AccountNo = @AccountNo;
	select Md.MessageID,Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as SentTo, Md.MailBoxID 
	from tblMailboxDetail Md, tblMailbox M , tblMessageType  Mt, tblInmate I where
	Md.MailBoxID = M.MailboxID and
	Md.MessageTypeID = Mt.MessageTypeID and
	M.InmateID = I.InmateID and
	M.FacilityID = I.FacilityId and 
	Md.MessageTypeID =2 and
	Md.SenderMailBoxID  =  @SenderMailboxID
	order by Md.MessageDate DESC;

	return @@error;
END

