
CREATE PROCEDURE [dbo].[UPDATE_NonRecordablePhone]
(
	@PhoneNo char(10),
	@FacilityID int,
	@LastName varchar(25),
	@FirstName varchar(25),
	@DescriptID smallint,
	@UserName varchar(25),
	@Original_PhoneNo char(10)
)
AS
SET NOCOUNT ON

IF @PhoneNo in (SELECT PhoneNo FROM tblNonRecordPhones WHERE PhoneNo <> @Original_PhoneNo)
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		UPDATE [tblNonRecordPhones] SET [PhoneNo] = @PhoneNo, [LastName] = @LastName, [FirstName] = @FirstName, 
				[DescriptID] = @DescriptID, [Username] = @Username
				WHERE PhoneNo = @Original_PhoneNo;
		RETURN 0;
	END

