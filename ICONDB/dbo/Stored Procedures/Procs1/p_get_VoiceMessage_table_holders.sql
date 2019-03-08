
CREATE PROCEDURE [dbo].[p_get_VoiceMessage_table_holders]

As


Select MailBoxId, MessageId, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension

from tblRecordingVoiceMessageTransHolder 

 
 
 

