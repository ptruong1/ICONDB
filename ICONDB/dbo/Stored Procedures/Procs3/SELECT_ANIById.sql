
CREATE PROCEDURE [dbo].[SELECT_ANIById]
(
	@ANINo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        ANINo, StationID, AccessTypeID, IDrequired, PINRequired, inputdate, modifyDate, DayTimeRestrict, UserName
FROM            tblANIs  with(nolock)
WHERE        (ANINo = @ANINo) AND (facilityID = @FacilityID);

