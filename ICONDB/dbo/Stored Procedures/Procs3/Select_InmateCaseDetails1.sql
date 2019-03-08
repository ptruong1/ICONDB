CREATE PROCEDURE [dbo].[Select_InmateCaseDetails1]

@caseID	int

AS
SELECT   [FacilityID], [CaseID], InmateID, [RecordID], max(InquiryNote) as InquiryNote, max(InquiryDate) as InquiryDate,  max(InquiryBy) as InquiryBy, max(NoteID) as NoteID FROM [tblCaseDetail]
where
     	 CaseID = @CaseID
	group by [FacilityID], [CaseID], InmateID, [RecordID]
