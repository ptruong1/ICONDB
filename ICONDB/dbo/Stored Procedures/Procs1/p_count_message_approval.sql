CREATE PROCEDURE [dbo].[p_count_message_approval]
@facilityID int
 AS
 select count(*) as messagecount from tblVisitors with(nolock) where FacilityID =@facilityID and Approved = 'P'


