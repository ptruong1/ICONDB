CREATE PROCEDURE [dbo].[Select_InmateCaseDetails] 

@caseID	int

AS
SELECT [FacilityID], [CaseID], [RecordID], [InquiryNote], [InquiryDate], [InmateID], [InquiryBy], NoteID FROM [tblCaseDetail]
where
     	 CaseID = @caseID
	order by caseID, recordID, inquiryDate
