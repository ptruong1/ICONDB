CREATE PROCEDURE [dbo].[INSERT_InmateCaseDetails]
@facilityID	int,
@caseID	int,
@RecordingID	bigint,
@InquiryNote	varchar(150),
@InquiryDate	smallDatetime,
@InmateID	varchar(12),
@InquiryBy	varchar(25)
AS

	INSERT tblCaseDetail(FacilityID,  CaseID  ,    RecordID   , InquiryNote   ,     InquiryDate,  InmateID ,    InquiryBy   )
	Values(      @facilityID, @caseID, @RecordingID,@InquiryNote,@InquiryDate,@InmateID,@InquiryBy)

 EXEC  INSERT_ActivityLogs1   @FacilityID,13, 0,	@InquiryBy,'', @caseID
