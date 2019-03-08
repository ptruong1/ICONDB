

CREATE PROCEDURE [dbo].[p_Update_FreeCalls_11202017]
(
	@PhoneNo char(10),
	@FirstName varchar(20),
	@LastName varchar(25),
	@Descript varchar(50),
	@Username varchar(25),
	@Original_PhoneNo char(10),
	@FacilityID int,
	@GroupID int,
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
	Declare @UserAction  varchar(100),@ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
	UPDATE [tblFreePhones] SET [PhoneNo] = @PhoneNo, [FirstName] = @FirstName, [LastName] = @LastName, [Descript] = @Descript, [Username] = @Username WHERE (([PhoneNo] = @Original_PhoneNo) AND (GroupID = @GroupID));
	
	SET  @UserAction =  'Edit Free Call: ' + @PhoneNo  ;
	EXEC  INSERT_ActivityLogs3	@FacilityID ,8,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ;
	
	

