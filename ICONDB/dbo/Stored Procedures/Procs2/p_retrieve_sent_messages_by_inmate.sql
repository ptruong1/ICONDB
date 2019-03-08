-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_sent_messages_by_inmate]
@InmateID varchar(12),
@FacilityID int	
AS
BEGIN
	/*
	select Md.MessageID,Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as SentTo, Md.MailBoxID 
	from tblMailboxDetailF Md, tblMailbox M , tblMessageType  Mt, tblInmate I where
	Md.SenderMailBoxID = M.MailboxID and
	Md.MessageTypeID = Mt.MessageTypeID and
	M.InmateID = I.InmateID and
	M.FacilityID = I.FacilityId and
	M.InmateID  = @InmateID and M.FacilityID =@FacilityID ;
	*/
	
	Declare @SenderMailboxID as int, @ReceiveMailboxID as int; 
	Select @SenderMailboxID  = mailboxID from tblMailbox with(nolock) where InmateID  =@InmateID and FacilityID =@FacilityID ;
	
	select Md.MessageID,Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as SentTo, Md.MailBoxID 
	from tblMailboxDetailF Md, tblMessageType  Mt, tblprepaid I ,tblMailboxF F where
	F.MailboxID = Md.MailBoxID and
	Md.MessageTypeID = Mt.MessageTypeID and
	F.AccountNo = I.PhoneNo and
	F.FacilityId = @FacilityID and
	Md.SenderMailBoxID = @SenderMailboxID and
	Md.MessageTypeID =2
	order by Md.MailBoxID,  Md.MessageID asc; 
	return @@error;
END

