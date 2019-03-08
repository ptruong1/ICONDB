
CREATE PROCEDURE [dbo].[p_get_VoiceMessage_transcriptRequest]

As


Select top 1 MailBoxId, MessageId, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension
into #temp 
from tblRecordingVoiceMessageTransHolder 
where 
	Mainstatus = 0 

Update [tblRecordingVoiceMessageTransHolder] 
set Mainstatus = 1, InStatus = 1, OutStatus = 1
from #temp
where #temp.MailBoxId = [tblRecordingVoiceMessageTransHolder].MailBoxId 
and #temp.MessageId = [tblRecordingVoiceMessageTransHolder].MessageId
--and #temp.extension = [tblRecordingListTransHolder].extension; 	

Select MailBoxId, MessageId, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension
from #temp 
 
 drop table #temp
 
 
 

