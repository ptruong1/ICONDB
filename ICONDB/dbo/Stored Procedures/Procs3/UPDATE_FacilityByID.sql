
CREATE PROCEDURE [dbo].[UPDATE_FacilityByID]
(
	@FacilityID int,
	@Location varchar(50),
	@Address varchar(50),
	@City varchar(20),
	@State char(2),
	@Phone char(10),
	@ContactName varchar(50),
	@ContactPhone char(10),
	@ContactEmail varchar(30),
	@MaxCallTime smallint,
	@Username varchar(20)
)
AS
	
SET NOCOUNT OFF;
IF @Phone in (SELECT Phone FROM tblFacility WHERE FacilityID <> @FacilityID)
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		UPDATE [tblFacility] SET [Location] = @Location, [Address] = @Address, [City] = @City, [State] = @State, [Phone] = @Phone, [ContactName] = @ContactName, [ContactPhone] = @ContactPhone, [ContactEmail] = @ContactEmail, [MaxCallTime] = @MaxCallTime, [UserName] = @UserName, [ModifyDate] = getdate() WHERE  [FacilityId] = @FacilityId;
		RETURN;
	END


