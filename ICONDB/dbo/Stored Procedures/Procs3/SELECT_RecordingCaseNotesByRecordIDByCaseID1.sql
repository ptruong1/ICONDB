CREATE PROCEDURE [dbo].[SELECT_RecordingCaseNotesByRecordIDByCaseID1]
( 
	
	@UserID varchar(25),
	@RecordID bigint,
	@CaseID int
	
)
AS
	SET NOCOUNT ON;
SELECT        tblCaseDetail.CaseID, [RecordID], [InquiryNote], [InquiryDate], [InmateID], [InquiryBy], Descript, OpenDate, NoteID FROM [tblCaseDetail]
	INNER Join tblCase on tblCase.CaseID = tblCaseDetail.CaseID
	 
     	 	WHERE InquiryBy = @UserID AND RecordID = @RecordID and  tblCaseDetail.CaseID=@CaseID
