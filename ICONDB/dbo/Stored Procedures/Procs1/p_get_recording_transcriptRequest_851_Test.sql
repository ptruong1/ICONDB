
Create PROCEDURE [dbo].[p_get_recording_transcriptRequest_851_Test]

As


Select top 1 RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension, UserLanguage
into #temp 
from tblRecordingListTransHolder 
where 
	Mainstatus = 0 

Update [dbo].[tblRecordingListTransHolder] 
set Mainstatus = 1, InStatus = 1, OutStatus = 1
from #temp
where #temp.recordID = [dbo].[tblRecordingListTransHolder].recordID and #temp.extension = [dbo].[tblRecordingListTransHolder].extension; 	

Select RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension, UserLanguage
from #temp 
 
 drop table #temp
 
 
 

