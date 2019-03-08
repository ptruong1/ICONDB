

CREATE PROCEDURE [dbo].[p_get_facility_time]
@facilityID int,
@ActTime	datetime  OUTPUT
AS
Begin
	SET NOCOUNT ON;
	Declare  @timezone	smallint;
	SET @timezone =0;
	select @timezone = isnull(timezone,0) from tblfacility with(nolock) where FacilityID =@facilityID ;
	SET  @ActTime = dateadd(hh, @timeZone,getdate());
	return @@error;
end

  



