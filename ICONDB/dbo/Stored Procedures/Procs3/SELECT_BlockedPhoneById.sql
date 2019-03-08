
CREATE PROCEDURE [dbo].[SELECT_BlockedPhoneById]
(
	@PhoneNo varchar(10),
	@FacilityID int
)
AS
	SET NOCOUNT ON;
IF @FacilityID = 1
BEGIN
	SELECT        PhoneNo, FacilityID, ReasonID, Username, InputDate,RequestID
	FROM            tblBlockedPhones  with(nolock)
	WHERE PhoneNo = @PhoneNo 
END
ELSE
BEGIN
	SELECT        PhoneNo, FacilityID, ReasonID, Username, InputDate,RequestID
	FROM            tblBlockedPhones  with(nolock)
	WHERE PhoneNo = @PhoneNo AND (FacilityID = @FacilityID or FacilityID = 1)
END



