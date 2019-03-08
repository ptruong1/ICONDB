-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_inbox_picture_messages_by_inmate_v1]
@InmateID varchar(12),
@FacilityID int,
@isNew bit	
AS
BEGIN
	select M.MailboxID, Md.MessageID, Md.MessageName ,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as [From], IsNew , Isnull(Message,'') PictureName
	from tblMailboxDetail Md, tblMailbox M , tblprepaid I, tblMailboxF Mf where
	Md.MailBoxID = M.MailboxID and
	Mf.MailboxID = md.SenderMailBoxID and
	Mf.AccountNo  = I.PhoneNo  and
	M.InmateID  = @InmateID and
	M.FacilityID = @FacilityID and
	Md.MessageStatus =2 and
	Md.IsNew = @isNew 	and 
	Md.MessageTypeID =5;

	return @@error;
END


