CREATE PROCEDURE [dbo].[p_get_facilityID]
as
SET NOCOUNT ON;
	select facilityID from   tblFacilityOption  with(nolock) where   AVSopt =1 ;
