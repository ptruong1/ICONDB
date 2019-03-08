﻿
CREATE PROCEDURE [dbo].[p_get_recording_to_table_holder_V2]

As


SELECT L.RecordID, C.FolderDate, C.userName, (select isnull(words,'') from tblRecordingTranscript I where L.TranscriptListID = I.TranscriptListID) as words,
(select TranscriptName from tblRecordingTranscript I where L.TranscriptListID = I.TranscriptListID) as TranscriptionName, 
'' CalleeText, '' CallerText, '' WordsMatch, RecordFile
  into #temp           
			  FROM [tblRecordingListTrans] L
              inner join tblCallsBilled C on L.RecordID = C.RecordID
			  --left join leg_Icon.dbo.tblRecordingTransMatch R on L.recordID = R.RecordID
              where status = 0 
			  --and (select count(*) from tblRecordingListTransHolder) = 0
			  and L.RecordID not in (select recordID from tblRecordingTransMatch)
			  order by L.InputDate ;

Update [tblRecordingListTrans] 
set status = 1, InStatus = 1, OutStatus = 1
from #temp
where #temp.recordID = [leg_Icon].[dbo].[tblRecordingListTrans].recordID ;

Insert into tblRecordingListTransHolder(RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension, MainStatus, Instatus, OutStatus)
Select RecordID, 
('\\' + UserName + '\home\ThirdPtDt_RmoteSver\' + ('ACP' + (PARSENAME([userName], 1))) + '\' + folderDate + '\' + Replace(RecordFile, '.WAV', '-out.wav')) as Inputwav,  
words, TranscriptionName, '' CalleeText, '' CallerText, '' WordsMatch, '-Out.wav' as Extension, 0, 0, 0

from #temp 
--where RecordID not in (select recordID from leg_Icon.dbo.tblRecordingTransMatch 



Insert into tblRecordingListTransHolder(RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension, MainStatus, Instatus, OutStatus)

Select RecordID, 
('\\' + UserName + '\home\ThirdPtDt_RmoteSver\' + ('ACP' + (PARSENAME([userName], 1))) + '\' + folderDate + '\' + Replace(RecordFile, '.WAV', '-in.wav')) as Inputwav, 
words, TranscriptionName, '' CalleeText, '' CallerText, '' WordsMatch, '-In.wav' as Extension, 0, 0, 0

from #temp 
--where RecordID not in (select recordID from leg_Icon.dbo.tblRecordingTransMatch 
select * from #temp

drop table #temp
	
 
 
 
 
 

