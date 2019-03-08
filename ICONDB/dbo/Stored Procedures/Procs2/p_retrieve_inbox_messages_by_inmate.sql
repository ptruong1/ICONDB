-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_inbox_messages_by_inmate]
@InmateID varchar(12),
@FacilityID int	
AS
BEGIN
	select Md.MessageID,Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as [From], IsNew , Md.MailBoxID , Mf.MailboxID  as SenderMailBoxID , ISNULL(Md.IsReply,0) IsReply, isnull(Md.CCEmails,'') as Email
	from tblMailboxDetail Md, tblMailbox M , tblMessageType  Mt, tblprepaid I, tblMailboxF Mf where
	Md.MailBoxID = M.MailboxID and
	Md.MessageTypeID = Mt.MessageTypeID and
	Mf.MailboxID = md.SenderMailBoxID and
	Mf.AccountNo  = I.PhoneNo  and
	M.InmateID  = @InmateID and
	M.FacilityID = @FacilityID and
	md.MessageStatus = 2
	and Md.MessageTypeID =2 

	UNION

	select Md.MessageID,Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as [From], IsNew , Md.MailBoxID , Mf.MailboxID  as SenderMailBoxID , ISNULL(Md.IsReply,0) IsReply, isnull(Md.CCEmails,'') as Email
	from tblMailboxDetail Md, tblMailbox M , tblMessageType  Mt, tblUserprofiles I, tblMailboxF Mf where
	Md.MailBoxID = M.MailboxID and
	Md.MessageTypeID = Mt.MessageTypeID and
	Mf.MailboxID = md.SenderMailBoxID and
	Mf.AccountNo  = I.UserID  and
	M.InmateID  = @InmateID and
	M.FacilityID = @FacilityID and
	md.MessageStatus = 2
	and Md.MessageTypeID =2 ;

	return @@error;
END


