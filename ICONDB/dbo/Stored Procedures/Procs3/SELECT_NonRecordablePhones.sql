

CREATE PROCEDURE [dbo].[SELECT_NonRecordablePhones]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
IF @FacilityID = 1
BEGIN
	SELECT TOP 100 PhoneNo, LastName, FirstName, T.Descript as [Description]
	FROM    tblNonRecordPhones A   with(nolock)  INNER JOIN tblDescript T   with(nolock)  ON T.DescriptID = A.DescriptID
	ORDER BY inputdate DESC
END

ELSE IF ( @FacilityID = 74 or @FacilityID = 75 or @FacilityID = 76 )
BEGIN
	SELECT  PhoneNo, LastName, FirstName, T.Descript as [Description]
	FROM    tblNonRecordPhones A   with(nolock)  INNER JOIN tblDescript T   with(nolock)  ON T.DescriptID = A.DescriptID
	WHERE FacilityID = 74 or FacilityID = 75 or FacilityID = 76
	ORDER BY inputdate DESC
END

ELSE
BEGIN
	SELECT  PhoneNo, LastName, FirstName, T.Descript as [Description]
	FROM    tblNonRecordPhones A   with(nolock)  INNER JOIN tblDescript T   with(nolock)  ON T.DescriptID = A.DescriptID
	WHERE FacilityID = @FacilityID
	ORDER BY inputdate DESC
END

