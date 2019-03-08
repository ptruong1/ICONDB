CREATE PROCEDURE [dbo].[p_select_voiceMessage_ByMailBoxID_MessageID]
(
	@facilityId int, 
	@MailBoxId int, 
	@MessageId int, 
	@messageTypeId tinyint
	
)
AS
	SET NOCOUNT ON;
select t1.FacilityID, t2.MailboxID, 'Received' as BoxType, t2.MessageID, t1.InmateID, t2.MessageTypeID,  
t2.FolderDate, t2.MessageDate,  REPLACE(REPLACE(t2.Message, char(13), ''), CHAR(10), '') as Message, t2.MessengerNo, 
t2.MessengerNo  as SenderMailBoxID  
 from tblMailboxDetail t2  with(nolock) 
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 
Where  t2.mailboxId = @MailBoxId and t2.messageId = @MessageId 
and t1.FacilityID = @facilityId and t2.MessageTypeID = @messageTypeId
