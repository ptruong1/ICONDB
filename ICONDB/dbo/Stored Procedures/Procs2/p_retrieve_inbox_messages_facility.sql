-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_inbox_messages_facility]
@facilityID int	
AS
BEGIN
	select Md.MessageID,Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as [From], IsNew , Md.MailboxID, Mi.MailboxID as SenderMailboxID, isnull(Md.IsReply,0) IsReply
	from tblMailboxDetailF Md, tblMailboxF M , tblMessageType   Mt with(nolock), tblInmate I with(nolock), tblMailbox Mi where
	Md.MailBoxID = M.MailboxID and
	Md.MessageTypeID = Mt.MessageTypeID and
	Mi.MailboxID = Md.SenderMailBoxID and
	Mi.InmateID = I.InmateID and
	Mi.FacilityID = @facilityID
	
	order by  Md.MessageID;
	return @@error;
END


