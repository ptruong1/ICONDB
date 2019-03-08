CREATE PROCEDURE [dbo].[SELECT_InmateCaseByFacilityID]
( 
	@FacilityID int
	
)
AS
	SET NOCOUNT ON;
SELECT [FacilityID], [CaseID], tblCase.Descript as Descript, isnull(OpenDate,'') as OpenDate, isnull(Status,'1') as Status , isnull(ClosedDate, '') as ClosedDate, 
tblTroubleTicketStatus.descript as CaseStatus 
	FROM [tblCase] 
	INNER JOIN tblTroubleTicketStatus ON tblCase.Status = tblTroubleTicketStatus.statusID
WHERE ([FacilityID] = @facilityID)
