-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_recording_Match_Report]
(
@facilityId smallint,
@TranscriptionName varchar(40)
)

AS
BEGIN

	SELECT M.RecordID
      ,[TrascriptDate] as TranscribedDate
      ,[WordsMatch]
      ,[CallerText]
      ,[CalleeText]
	  ,[UserName]
  FROM [dbo].[tblRecordingTransMatch] M
  inner join tblRecordingListTrans L on M.recordId = L.recordId
  inner join tblRecordingTranscript T on L.TranscriptListID = T.TranscriptListID
  where T.TranscriptName = @TranscriptionName
  and WordsMatch <> ''
  and datediff(day,M.TrascriptDate,getdate()) < 1

END
