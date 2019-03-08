
CREATE PROCEDURE [dbo].[p_update_facility_visit_allowed]
(
	@FacilityID int,
	@UserID varchar(20),
	@UserIP varchar(25),
	@VisitPerDay int,
	@VisitPerWeek int,
	@VisitPerMonth int
)
AS
	SET NOCOUNT OFF;
Declare @UserAction varchar(200)
update tblVisitFacilityConfig SET VisitPerDay=@VisitPerDay, VisitPerWeek =@VisitPerWeek, VisitPerMonth=@VisitPerMonth where FacilityID=@FacilityID

Set @UserAction = 'Update visit allowed configuration of facility'
EXEC  INSERT_ActivityLogs5   @FacilityID,51, @UserAction, @UserID, @UserIP

