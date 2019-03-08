CREATE PROCEDURE [dbo].[INSERT_InmateCaseRecord]
@CaseID  	 int OUTPUT,
@facilityID	int,
@Descript	varchar(150),
@OpenDate	smallDatetime,
@ClosedDate	smallDatetime,
@Status	int
AS
INSERT tblCase(FacilityID,   Descript,  OpenDate,  ClosedDate, Status   )
Values(      @facilityID, @Descript,@OpenDate,@ClosedDate, @status );
SET @CaseID  = SCOPE_IDENTITY()
