﻿
CREATE PROCEDURE [dbo].[UPDATE_NonRecordablePhone1]
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
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
IF @PhoneNo in (SELECT PhoneNo FROM tblNonRecordPhones WHERE PhoneNo <> @Original_PhoneNo)
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		UPDATE [tblNonRecordPhones] SET [PhoneNo] = @PhoneNo, [LastName] = @LastName, [FirstName] = @FirstName, 
				[DescriptID] = @DescriptID, [Username] = @Username
				WHERE PhoneNo = @Original_PhoneNo;
				SET  @UserAction =  'Edit NonRecorable Phone: ' + @Original_PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,17,@ActTime ,0,@UserName ,'', @PhoneNo ,@UserAction ;  
		RETURN 0;
	END

