
CREATE PROCEDURE [dbo].[SELECT_NonRecordablePhoneById]
(
	@PhoneNo varchar(10),
	@FacilityID int
)
AS
	SET NOCOUNT ON;
IF @FacilityID != 1
BEGIN
	SELECT        PhoneNo, LastName, FirstName, DescriptID, Username, InputDate
	FROM            tblNonRecordPhones  with(nolock)
	WHERE PhoneNo = @PhoneNo AND FacilityID = @FacilityID
END
ELSE
BEGIN
	SELECT        PhoneNo, LastName, FirstName, DescriptID, Username, InputDate
	FROM            tblNonRecordPhones  with(nolock)
	WHERE PhoneNo = @PhoneNo 
END

