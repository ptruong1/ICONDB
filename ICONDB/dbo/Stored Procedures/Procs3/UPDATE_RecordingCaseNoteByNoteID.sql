CREATE PROCEDURE [dbo].[UPDATE_RecordingCaseNoteByNoteID]
(
	@InquiryNote varchar(200),
	@CaseID int,
	@RecordID bigint,
	@facilityID int,
	@NoteID bigint
)
AS
	SET NOCOUNT OFF;
UPDATE [tblCaseDetail] SET [inquiryNote] = @InquiryNote

WHERE FacilityID = @FacilityId and CaseID = @caseID  and NoteID=@NoteID and RecordID=@RecordID
