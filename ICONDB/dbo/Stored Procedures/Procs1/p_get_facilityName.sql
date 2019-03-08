CREATE PROCEDURE [dbo].[p_get_facilityName](@facilityID int)
as
SET NOCOUNT ON;
	select Location from tblFacility  with(nolock) where   FacilityID = @facilityID ;
