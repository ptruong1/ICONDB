
CREATE PROCEDURE [dbo].[p_get_VoiceMessages_to_table_holder]

As


select t1.FacilityID, t2.MailboxID, 'Received' as BoxType, t2.MessageID, t1.InmateID, t2.MessageTypeID,  
t2.FolderDate, t2.MessageDate,  REPLACE(REPLACE(t2.Message, char(13), ''), CHAR(10), '') as Message, t2.MessengerNo, 
t2.MessengerNo  as SenderMailBoxID,
(select isnull(words,'') from tblRecordingTranscript I where L.TranscriptListID = I.TranscriptListID) as words,
(select TranscriptName from tblRecordingTranscript I where L.TranscriptListID = I.TranscriptListID) as TranscriptionName  
   into #temp           
from tblMailboxDetail t2  with(nolock) 
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 
inner join [tblRecordingVoiveMessages] L on t2.mailboxId = L.MailBoxId and t2.messageId = L.MessageId 
where L.status = 0 

Update [tblRecordingVoiveMessages]
set status = 1, InStatus = 1, OutStatus = 1
from #temp t2
where t2.mailboxId = tblRecordingVoiveMessages.MailBoxId and t2.messageId = tblRecordingVoiveMessages.MessageId ;


Insert into tblRecordingVoiceMessageTransHolder(MailBoxId, MessageId, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension, MainStatus, Instatus, OutStatus)
Select MailBoxId, MessageId, 
('\\172.77.10.21\Mediafiles1\Messenger1\' + CAST(FacilityId as varchar(3))  + '\' + folderDate + '\' + Message ) as Inputwav,  
words, TranscriptionName, '' CalleeText, '' CallerText, '' WordsMatch, '-In.wav' as Extension, 0, 0, 0

from #temp 

Insert into tblRecordingVoiceMessageTransHolder(MailBoxId, MessageId, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension, MainStatus, Instatus, OutStatus)
 
select T.MailboxID, T.MessageID, 
('\\172.77.10.21\Mediafiles1\Messenger1\' + CAST(FacilityId as varchar(3))  + '\' + t2.FolderDate + '\' + replace(cast(t2.Message as varchar(max)), CHAR(13) + CHAR(10) ,'')) as Inputwav,  
words, TranscriptionName, '' CalleeText, '' CallerText, '' WordsMatch, '-Out.wav' as Extension, 0, 0, 0
from tblMailboxDetailF t2  with(nolock) 
inner join #temp T on t2.MailBoxID = (select MailBoxId from tblMailBoxF F where T.SenderMailBoxID = F.AccountNo)
and T.messageId = t2.MessageID

select * from tblRecordingVoiceMessageTransHolder

drop table #temp


	
 
 
 
 
 

