-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_inbox_messages_by_inmate_ICON]
@InmateID varchar(12),
@FacilityID int,
@fromDate datetime,
@todate	datetime
AS
BEGIN
	select Md.MessageID,Mt.Descript as MessageType, Md.MessageName,Md.MessageDate, Md.Message, 
	Md.MessengerNo, (P.LastName + ', ' + P.FirstName) as [From],
	(I.LastName + ', ' + I.FirstName) as [To], IsNew , Md.MailBoxID , Mf.MailboxID  as SenderMailBoxID , 
	ISNULL(Md.IsReply,0) IsReply, Md.CCEmails as Email, S.MessStatus as [MessStatus], S.Descript as [status], Md.ReviewNote
	from tblMailboxDetail Md, tblMailbox M , tblMessageType  Mt, tblInmate I, tblMailboxF Mf, [tblPrepaid] P, [tblMessageStatus] S
	where
	Md.MailBoxID = M.MailboxID and
	Md.MessageTypeID = Mt.MessageTypeID and
	Mf.MailboxID = md.SenderMailBoxID and
	M.InmateID = I.InmateID and
	Mf.FacilityID = I.FacilityId and
	--Md.MessengerNo = P.PhoneNo and
	Mf.AccountNo = P.PhoneNo and
	Md.MessageStatus = S.MessStatus and
	M.InmateID  = @InmateID and
	M.FacilityID = @FacilityID And 
			(Md.MessageDate between @fromDate and dateadd(d,1,@todate))
			order by Md.MessageDate desc;
			
	return @@error;
END


