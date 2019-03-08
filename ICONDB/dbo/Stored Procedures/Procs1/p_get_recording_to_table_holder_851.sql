-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_recording_to_table_holder_851]
AS
BEGIN
	SELECT L.RecordID, C.FolderDate, C.userName, isnull(words,'')  as words,
TranscriptName as TranscriptionName, '' CalleeText, '' CallerText, '' WordsMatch, RecordFile, ComputerName as [HostName], Channel,
(select LanguageContent from tblLanguages where ACPSelectOpt = (select languageID from tblFacilityLanguages where LanguageOrder =ISNULL(C.UserLanguage,1) and facilityID=C.FacilityID)) UserLanguage,
C.facilityId, (select isnull(Record2SideOpt, 0) from tblFacilityOption where facilityId = C.FacilityId) as Record2SideOpt,
I.UserName as userId
  into #temp           
			  FROM [tblRecordingListTrans] L
              inner join tblCallsBilled C on L.RecordID = C.RecordID
			  inner join tblRecordingTranscript I on L.TranscriptListID = I.TranscriptListID
			  INNER JOIN tblACPs on C.userName = IPAddress 
              where L.status = 0 
			  and L.RecordID not in (select recordID from tblRecordingTransMatch)
			  order by L.InputDate ;

Update [tblRecordingListTrans] 
set status = 1, InStatus = 1, OutStatus = 1
from #temp
where #temp.recordID = [tblRecordingListTrans].recordID ;


Insert into tblRecordingListTransHolder(RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  
Extension, MainStatus, Instatus, OutStatus, UserLanguage)
Select RecordID,
case when  Record2SideOpt = 1 then
('\\192.168.1.204\ACPsThirdPartyDetection\' + Hostname + '\line00\' + folderDate + '\' + Replace(RecordFile, '.WAV', '-out.wav')) 
else 
('\\' + UserName + '\home\ThirdPtDt_RmoteSver\' + ('ACP' + (PARSENAME([userName], 1))) + '\' + folderDate + '\' + Replace(RecordFile, '.WAV', '-out.wav'))
end as Inputwav,  
words, TranscriptionName, '' CalleeText, '' CallerText, '' WordsMatch, '-Out.wav' as Extension, 0, 0, 0,
case when UserLanguage = 'es-US' then 'es-MX' else Userlanguage end as UserLanguage

from #temp 

Insert into tblRecordingListTransHolder(RecordID, Inputwav, words, TranscriptionName, CalleeText, CallerText, WordsMatch,  Extension, MainStatus, Instatus, OutStatus, UserLanguage)

Select RecordID, 
case when  Record2SideOpt = 1 then
('\\192.168.1.204\ACPsThirdPartyDetection\' + Hostname + '\line00\' + folderDate + '\' + Replace(RecordFile, '.WAV', '-in.wav')) 
else
('\\' + UserName + '\home\ThirdPtDt_RmoteSver\' + ('ACP' + (PARSENAME([userName], 1))) + '\' + folderDate + '\' + Replace(RecordFile, '.WAV', '-in.wav'))
end as Inputwav, 
words, TranscriptionName, '' CalleeText, '' CallerText, '' WordsMatch, '-In.wav' as Extension, 0, 0, 0,
case when userLanguage = 'es-US' then 'es-MX' else userlanguage end as UserLanguage

from #temp 

select * from #temp

drop table #temp
END
