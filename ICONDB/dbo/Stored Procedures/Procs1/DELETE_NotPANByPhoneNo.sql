CREATE PROCEDURE [dbo].[DELETE_NotPANByPhoneNo]
(
	@PhoneNo Varchar(12),
	@FacilityID int,
	@InmateID varchar(12)
)
AS
BEGIN
	SET NOCOUNT OFF;
	DELETE FROM tblBlockedPhonesByPIN  WHERE PhoneNo=@PhoneNo and FacilityID=@FacilityID and 	InmateID=@InmateID ;
END
