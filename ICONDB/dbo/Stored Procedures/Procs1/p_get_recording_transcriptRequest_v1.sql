
CREATE PROCEDURE [dbo].[p_get_recording_transcriptRequest_v1]

As


SELECT top 5 L.RecordID, C.FolderDate, C.userName, (select words from tblRecordingTranscript I where L.TranscriptListID = I.TranscriptListID) as words, R.CalleeText, R.CallerText, R.WordsMatch
  into #temp           
			  FROM [leg_Icon].[dbo].[tblRecordingListTrans] L
              inner join [leg_Icon].[dbo].tblCallsBilled C on L.RecordID = C.RecordID
			  left join leg_Icon.dbo.tblRecordingTransMatch R on L.recordID = R.RecordID
              where status = 0
			  order by L.InputDate ;

Update [leg_Icon].[dbo].[tblRecordingListTrans] 
set status = 1
from #temp
where #temp.recordID = [leg_Icon].[dbo].[tblRecordingListTrans].recordID ;

Select * from #temp;

drop table #temp

	
 
 
 
 
 

