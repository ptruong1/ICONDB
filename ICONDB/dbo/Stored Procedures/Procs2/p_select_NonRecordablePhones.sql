CREATE PROCEDURE [dbo].[p_select_NonRecordablePhones]
(
	@GroupID int
)
AS
	SET NOCOUNT ON;
IF @GroupID = 1
BEGIN
	SELECT TOP 100 PhoneNo, LastName, FirstName, T.Descript as [Description], A.DescriptID,Inputdate
	FROM    tblNonRecordPhones A   with(nolock)  INNER JOIN tblDescript T   with(nolock)  ON T.DescriptID = A.DescriptID
	ORDER BY inputdate DESC
END

ELSE IF ( @GroupID = 74 or @GroupID = 75 or @GroupID = 76 )
BEGIN
	SELECT  PhoneNo, LastName, FirstName, T.Descript as [Description], A.DescriptID,Inputdate
	FROM    tblNonRecordPhones A   with(nolock)  INNER JOIN tblDescript T   with(nolock)  ON T.DescriptID = A.DescriptID
	WHERE groupID = 74 or groupID = 75 or groupID= 76
	ORDER BY inputdate DESC
END

ELSE
BEGIN
	SELECT distinct PhoneNo, LastName, FirstName, T.Descript as [Description], A.DescriptID,Inputdate
	FROM    tblNonRecordPhones A   with(nolock)  INNER JOIN tblDescript T   with(nolock)  ON T.DescriptID = A.DescriptID
	WHERE groupID = @GroupID
	ORDER BY inputdate, PhoneNo DESC
END

