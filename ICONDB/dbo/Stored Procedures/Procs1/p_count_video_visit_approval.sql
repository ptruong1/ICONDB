CREATE PROCEDURE [dbo].[p_count_video_visit_approval]
@facilityID int
 AS
 select count(*) as videovisitcount from tblVisitEnduserSchedule with(nolock) where FacilityID =@facilityID and status =1


