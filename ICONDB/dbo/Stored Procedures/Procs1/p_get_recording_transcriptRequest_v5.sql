
CREATE PROCEDURE [dbo].[p_get_recording_transcriptRequest_v5]

As


Select RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension
into #temp 
from tblRecordingListTransHolder 
--where 
--	Mainstatus = 0 

Update [leg_Icon].[dbo].[tblRecordingListTransHolder] 
set Mainstatus = 1, InStatus = 1, OutStatus = 1
from #temp
where #temp.recordID = [leg_Icon].[dbo].[tblRecordingListTransHolder].recordID ; 	

Select RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension
from #temp 
 
 drop table #temp
 
 
 

