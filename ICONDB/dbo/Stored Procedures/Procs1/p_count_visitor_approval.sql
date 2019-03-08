CREATE PROCEDURE [dbo].[p_count_visitor_approval]
@facilityID int
 AS
 select count(*) as visitorcount 
 from tblVisitors V,[tblInmate] I,[tblVisitorStatus] S
 where V.FacilityID =@facilityID 
			and V.InmateID = I.InmateID
			and V.FacilityID = I.FacilityID
			and V.Approved = S.Status
			and V.Approved = 'P'


