
CREATE PROCEDURE [dbo].[p_get_recording_transcriptRequest_v2]

As


SELECT top 10 L.RecordID, C.FolderDate, C.userName, (select words from tblRecordingTranscript I where L.TranscriptListID = I.TranscriptListID) as words, 
'' CalleeText, '' CallerText, '' WordsMatch
  into #temp           
			  FROM [leg_Icon].[dbo].[tblRecordingListTrans] L
              inner join [leg_Icon].[dbo].tblCallsBilled C on L.RecordID = C.RecordID
			  --left join leg_Icon.dbo.tblRecordingTransMatch R on L.recordID = R.RecordID
              where status = 0
			  order by L.InputDate ;

Update [leg_Icon].[dbo].[tblRecordingListTrans] 
set status = 1, InStatus = 1, OutStatus = 1
from #temp
where #temp.recordID = [leg_Icon].[dbo].[tblRecordingListTrans].recordID ;

Select * from #temp 
where RecordID not in (select recordID from leg_Icon.dbo.tblRecordingTransMatch );

drop table #temp

	
 
 
 
 
 

