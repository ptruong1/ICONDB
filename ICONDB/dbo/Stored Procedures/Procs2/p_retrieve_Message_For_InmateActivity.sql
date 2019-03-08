-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_Message_For_InmateActivity]
@facilityID int,
@MessageTypeID int,
@MailboxID int,
@MessageID int	
AS
BEGIN
	select t1.FacilityID, t2.MailboxID, 'Received' as BoxType, t2.MessageID, t1.InmateID, t2.MessageTypeID, t5.Descript as MessageType,
 t2.MessageName, t2.FolderDate, t2.MessageDate, t2.Message as Message, 
 t2.MessengerNo, (t7.LastName + ', ' + t7.FirstName) as [From], (t3.LastName + ', ' + t3.FirstName) as [To], IsNew , 
 t2.MessengerNo  as SenderMailBoxID , ISNULL(t2.IsReply,0) IsReply, isnull(t2.CCEmails,'') as Email, isnull(t2.MessageStatus,1) as [MessStatus], 
 t8.Descript as [status], isnull(t2.ReviewNote,'') as ReviewNote, t2.ApprovedBy,t2.ApprovedDate,t2.DeniedDate,t2.DeniedBy 
 from tblMailboxDetail t2  with(nolock) 
 
 left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID  
 left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 
 left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID
 left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 
 left join tblPrepaid t7 with(nolock) on t2.MessengerNo = t7.PhoneNo 
 left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus  
  Where   
  
  t1.FacilityID = @facilityID and 
  t2.MessageTypeID = @MessageTypeID and
  t1.MailboxID = @MailBoxID and
  t2.messageID = @MessageID

End
