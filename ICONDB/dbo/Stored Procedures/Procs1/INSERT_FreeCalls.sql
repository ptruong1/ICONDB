

CREATE PROCEDURE [dbo].[INSERT_FreeCalls]
(
	@PhoneNo char(10),
	@FacilityID int,
	@FirstName varchar(20),
	@LastName varchar(25),
	@Descript varchar(50),
	@Username varchar(25)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [tblFreePhones] ([PhoneNo], [FacilityID], [FirstName], [LastName], [Descript], [Username]) VALUES (@PhoneNo, @FacilityID, @FirstName, @LastName, @Descript, @Username);

EXEC  INSERT_ActivityLogs1   @FacilityID,8, 0,	@userName,'', @PhoneNo
