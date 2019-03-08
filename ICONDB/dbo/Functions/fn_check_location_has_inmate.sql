-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION fn_check_location_has_inmate
(
	@ANI char(10),
	@InmateID varchar(12),
	@FacilityID	int
)
RETURNS int 
AS
BEGIN
	IF (select count(*) from tblANIsInmateRestrict where ANI = @ANI) > 0
	 Begin
		IF (select count(*) from tblANIsInmateRestrict where ANI = @ANI and InmateID=@InmateID and facilityID =@FacilityID) > 0
			Return 1;
		else
			Return 0;
	 End
	Return 1;
END
