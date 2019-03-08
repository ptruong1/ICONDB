
CREATE PROCEDURE [dbo].[UPDATE_BlockedPhone]
(
	@PhoneNo char(10),
	@FacilityID int,
	@ReasonID tinyint,
	@UserName varchar(25),
	@RequestID tinyint,
	@Original_PhoneNo char(10)
)
AS

IF @PhoneNo in (SELECT PhoneNo FROM tblNonRecordPhones WHERE PhoneNo <> @Original_PhoneNo AND (FacilityID=@FacilityID or FacilityID=1))
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		UPDATE [tblBlockedPhones] SET [PhoneNo] = @PhoneNo, ReasonID=@ReasonID, [Username] = @Username, [RequestID] = @RequestID
		WHERE PhoneNo = @Original_PhoneNo;
		RETURN 0;
	END




