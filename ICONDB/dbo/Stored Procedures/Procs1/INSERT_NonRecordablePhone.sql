
CREATE PROCEDURE [dbo].[INSERT_NonRecordablePhone]
(
	@PhoneNo char(10),
	@FacilityID int,
	@LastName varchar(25),
	@FirstName varchar(25),
	@DescriptID smallint,
	@UserName varchar(25)
)
AS
	SET NOCOUNT OFF;
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
IF (SELECT count(PhoneNo) FROM tblNonRecordPhones with(nolock) where PhoneNo =@PhoneNo and FacilityID = @FacilityID) >0
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		INSERT INTO [tblNonRecordPhones] ([PhoneNo], [FacilityID], [LastName], [FirstName], [DescriptID], [UserName],Inputdate) 
		VALUES (@PhoneNo, @FacilityID, @LastName, @FirstName, @DescriptID, @UserName,@ActTime);
		--EXEC  INSERT_ActivityLogs1   @FacilityID,8, 0,	@userName,'', @PhoneNo
		SET  @UserAction =  'Add Non-recordable phone: ' + @PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,8,@ActTime ,0,@UserName ,'', @PhoneNo ,@UserAction ;  
		RETURN @@error;
	END
