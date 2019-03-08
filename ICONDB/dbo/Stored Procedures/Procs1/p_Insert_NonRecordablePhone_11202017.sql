
CREATE PROCEDURE [dbo].[p_Insert_NonRecordablePhone_11202017]
(
	@PhoneNo char(10),
	@FacilityID int,
	@GroupID int,
	@LastName varchar(25),
	@FirstName varchar(25),
	@DescriptID smallint,
	@UserName varchar(25),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
IF (SELECT count(PhoneNo) FROM tblNonRecordPhones with(nolock) where PhoneNo =@PhoneNo and groupID = @GroupID) >0
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		INSERT INTO [tblNonRecordPhones] ([PhoneNo], [FacilityID], [LastName], [FirstName], [DescriptID], [UserName],Inputdate, groupID) 
		VALUES (@PhoneNo, @FacilityID, @LastName, @FirstName, @DescriptID, @UserName,@ActTime, @GroupID);
		--EXEC  INSERT_ActivityLogs1   @FacilityID,8, 0,	@userName,'', @PhoneNo
		SET  @UserAction =  'Add Non-recordable phone: ' + @PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,17,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ;  
		RETURN @@error;
	END

