CREATE PROCEDURE [dbo].[DELETE_PANByPhoneNo]
(
	@PhoneNo Varchar(12),
	@FacilityID int,
	@PIN varchar(12)
)
AS
	SET NOCOUNT OFF;
DELETE FROM tblBlockedPhonesByPIN
 WHERE PhoneNo=@PhoneNo and
	  FacilityID=@FacilityID and
	  PIN=@PIN
