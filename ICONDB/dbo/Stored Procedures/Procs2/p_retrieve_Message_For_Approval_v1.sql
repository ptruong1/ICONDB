﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[p_retrieve_Message_For_Approval_v1]
@facilityID int,
@MessageTypeID int	
AS
BEGIN
If @MessageTypeID = 4
begin 
(select t1.FacilityID, t2.MailboxID, 'Received' as BoxType, t2.MessageID, t1.InmateID, 
t2.MessageTypeID, t5.Descript as MessageType, t2.MessageName, t2.FolderDate, t2.MessageDate,isnull(t2.DeviceName,'NA') as [DeviceName],  
REPLACE(REPLACE(t2.Message, char(13), '<br/>'), CHAR(10), '<br/>') as Message, 
t2.MessengerNo, (t7.LastName + ', ' + t7.FirstName) as [From], 
(t3.LastName + ', ' + t3.FirstName) as [To], 
IsNew , t2.MessengerNo  as SenderMailBoxID , ISNULL(t2.IsReply,0) IsReply, isnull(t2.CCEmails,'') as Email, 
isnull(t2.MessageStatus,1) as [MessStatus], t8.Descript as [status], isnull(t2.ReviewNote,'') as ReviewNote, ISNULL(MonitorOpt,'Y') as MonitorOpt
from tblMailboxDetail t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblPrepaid t7 with(nolock) on t2.MessengerNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus   
Where   

t1.FacilityID = @facilityID 
and (t2.MessageTypeID = 4 and VideoStatus =2) and
isnull(t2.MessageStatus,1) = 1 and
t2.MessageTypeID = @MessageTypeID
Union 
select t1.FacilityID, t2.MailboxID, 'Sent' as BoxType, t2.MessageID, t1.InmateID, 
t2.MessageTypeID, t5.Descript as MessageType, t2.MessageName, t2.FolderDate, t2.MessageDate,  isnull(t2.DeviceName,'NA') as [DeviceName],  
replace(cast(t2.Message as varchar(max)), CHAR(13) + CHAR(10) ,'<br />') as Message, 
t6.AccountNo, (t3.LastName + ', ' + t3.FirstName) as [From], 
(t7.LastName + ', ' + t7.FirstName) as [To], 
IsNew , t6.AccountNo  as SenderMailBoxID , ISNULL(t2.IsReply,0) IsReply, isnull(t2.Email,'') as Email, 
isnull(t2.MessageStatus,1) as [MessStatus], t8.Descript as [status], isnull(t2.ReviewNote,'') as ReviewNote ,ISNULL(MonitorOpt,'Y') as MonitorOpt
from tblMailboxDetailF t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblMailboxF t6 with(nolock) on t2.MailBoxID = t6.MailBoxID 	
left join tblPrepaid t7 with(nolock) on t6.AccountNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus  
Where  
--(t2.MessageDate between '4/1/2015' and dateadd(d,1,'4/16/2015')) and 
t1.FacilityID = @facilityID 
and (t2.MessageTypeID = 4 and VideoStatus =2) and
isnull(t2.MessageStatus,1) = 1  and
t2.MessageTypeID = @MessageTypeID)
order by t2.MessageDate desc,  t2.MailBoxID 

end
else

	(select t1.FacilityID, t2.MailboxID, 'Received' as BoxType, t2.MessageID, t1.InmateID, 
t2.MessageTypeID, t5.Descript as MessageType, t2.MessageName, t2.FolderDate, t2.MessageDate, isnull(t2.DeviceName,'NA') as [DeviceName],   
REPLACE(REPLACE(t2.Message, char(13), '<br/>'), CHAR(10), '<br/>') as Message, 
t2.MessengerNo, (t7.LastName + ', ' + t7.FirstName) as [From], 
(t3.LastName + ', ' + t3.FirstName) as [To], 
IsNew , t2.MessengerNo  as SenderMailBoxID , ISNULL(t2.IsReply,0) IsReply, isnull(t2.CCEmails,'') as Email, 
isnull(t2.MessageStatus,1) as [MessStatus], t8.Descript as [status], isnull(t2.ReviewNote,'') as ReviewNote,ISNULL(MonitorOpt,'Y') as MonitorOpt 
from tblMailboxDetail t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblPrepaid t7 with(nolock) on t2.MessengerNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus   
Where   

t1.FacilityID = @facilityID 
and t2.MessageTypeID = @MessageTypeID and
isnull(t2.MessageStatus,1) = 1 and
t2.MessageTypeID = @MessageTypeID
Union 
select t1.FacilityID, t2.MailboxID, 'Sent' as BoxType, t2.MessageID, t1.InmateID, 
t2.MessageTypeID, t5.Descript as MessageType, t2.MessageName, t2.FolderDate, t2.MessageDate,   isnull(t2.DeviceName,'NA') as [DeviceName],
replace(cast(t2.Message as varchar(max)), CHAR(13) + CHAR(10) ,'<br />') as Message, 
t6.AccountNo, (t3.LastName + ', ' + t3.FirstName) as [From], 
(t7.LastName + ', ' + t7.FirstName) as [To], 
IsNew , t6.AccountNo  as SenderMailBoxID , ISNULL(t2.IsReply,0) IsReply, isnull(t2.Email,'') as Email, 
isnull(t2.MessageStatus,1) as [MessStatus], t8.Descript as [status], isnull(t2.ReviewNote,'') as ReviewNote ,ISNULL(MonitorOpt,'Y') as MonitorOpt
from tblMailboxDetailF t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblMailboxF t6 with(nolock) on t2.MailBoxID = t6.MailBoxID 	
left join tblPrepaid t7 with(nolock) on t6.AccountNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus  
Where  
--(t2.MessageDate between '4/1/2015' and dateadd(d,1,'4/16/2015')) and 
t1.FacilityID = @facilityID 
and t2.MessageTypeID = @MessageTypeID and
isnull(t2.MessageStatus,1) = 1  and
t2.MessageTypeID = @MessageTypeID)
order by t2.MessageDate desc,  t2.MailBoxID 

End
