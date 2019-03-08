
CREATE PROCEDURE [dbo].[p_get_recording_transcriptRequest_v5_Test]

As


Select top 1 RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension
into #temp 
from tblRecordingListTransHolder 
where 
	Mainstatus = 0 

Update [leg_Icon].[dbo].[tblRecordingListTransHolder] 
set Mainstatus = 1, InStatus = 1, OutStatus = 1
from #temp
where #temp.recordID = [leg_Icon].[dbo].[tblRecordingListTransHolder].recordID and #temp.extension = [leg_Icon].[dbo].[tblRecordingListTransHolder].extension; 	

Select RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension
from #temp 
 
 drop table #temp
 
 
 

