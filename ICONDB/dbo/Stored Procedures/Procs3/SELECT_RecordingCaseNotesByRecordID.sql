CREATE PROCEDURE [dbo].[SELECT_RecordingCaseNotesByRecordID]
( 
	
	@UserID varchar(25),
	@RecordID bigint
)
AS
	SET NOCOUNT ON;
SELECT        tblCaseDetail.CaseID, [RecordID], [InquiryNote], [InquiryDate], [InmateID], [InquiryBy], Descript, OpenDate FROM [tblCaseDetail]
	INNER Join tblCase on tblCase.CaseID = tblCaseDetail.CaseID
	 
     	 	WHERE InquiryBy = @UserID AND RecordID = @RecordID
