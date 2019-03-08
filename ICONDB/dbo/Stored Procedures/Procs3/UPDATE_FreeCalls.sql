

CREATE PROCEDURE [dbo].[UPDATE_FreeCalls]
(
	@PhoneNo char(10),
	@FirstName varchar(20),
	@LastName varchar(25),
	@Descript varchar(50),
	@Username varchar(25),
	@Original_PhoneNo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
	UPDATE [tblFreePhones] SET [PhoneNo] = @PhoneNo, [FirstName] = @FirstName, [LastName] = @LastName, [Descript] = @Descript, [Username] = @Username WHERE (([PhoneNo] = @Original_PhoneNo) AND ([FacilityID] = @FacilityID));
	
	

