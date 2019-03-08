-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[p_retrieve_inbox_video_messages_v1]
@AcountNo varchar(12),
@FacilityID int	
AS
BEGIN
	select M.MailboxID, Md.MessageID, Md.MessageName ,Md.MessageDate, 
	(I.LastName + ', ' + I.FirstName) as [From], IsNew , Isnull(Message,'') VideoMessage
	from tblMailboxDetailF Md, tblMailboxF M , tblInmate I, tblMailbox Mf where
	Md.MailBoxID = M.MailboxID and
	Md.SenderMailBoxID =Mf.MailboxID  and
	M.AccountNo  = @AcountNo  and
	I.InmateID  = Mf.InmateID and
	I.facilityID = Mf.FacilityID and
	I.facilityID = M.FacilityID and
	Mf.FacilityID = @FacilityID and
	Md.MessageStatus =2 
	and Md.MessageTypeID =4 ;

	return @@error;
END

