
CREATE PROCEDURE [dbo].[p_get_table_holders]

As


Select RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension

from tblRecordingListTransHolder 

 
 
 

