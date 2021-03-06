﻿

CREATE PROCEDURE [dbo].[p_Insert_FreeCalls]
(
	@PhoneNo char(10),
	@FacilityID int,
	@FirstName varchar(20),
	@LastName varchar(25),
	@Descript varchar(50),
	@Username varchar(25),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
	Declare @UserAction  varchar(100),@ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 

INSERT INTO [tblFreePhones] ([PhoneNo], [FacilityID], [FirstName], [LastName], [Descript], [Username]) VALUES (@PhoneNo, @FacilityID, @FirstName, @LastName, @Descript, @Username);

SET  @UserAction =  'Add Free Call: ' + @PhoneNo  ;
	EXEC  INSERT_ActivityLogs3	@FacilityID ,8,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ; 
