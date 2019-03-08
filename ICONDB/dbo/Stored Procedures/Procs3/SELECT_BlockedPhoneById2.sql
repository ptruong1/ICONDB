
CREATE PROCEDURE [dbo].[SELECT_BlockedPhoneById2]
(
	@PhoneNo varchar(10),
	@FacilityID int
)
AS
	SET NOCOUNT ON;
IF (@FacilityID = 1 Or @FacilityID = 2  or  @FacilityID = 0)
BEGIN
	SELECT        PhoneNo, FacilityID, ReasonID, Descript, TimeLimited, Username, InputDate,RequestID
	FROM            tblBlockedPhones  with(nolock)
	WHERE PhoneNo = @PhoneNo 
END
ELSE
BEGIN
	SELECT        PhoneNo, FacilityID, ReasonID, Descript,TimeLimited, Username, InputDate,RequestID
	FROM            tblBlockedPhones  with(nolock)
	WHERE PhoneNo = @PhoneNo AND (FacilityID = @FacilityID or FacilityID = 1)
END

