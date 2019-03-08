
CREATE PROCEDURE [dbo].[p_Update_BlockedPhone]
(
	@PhoneNo char(10),
	@FacilityID int,
	@ReasonID tinyint,
	@Descript char(200),
	@UserName varchar(25),
	@RequestID tinyint,
	@Original_PhoneNo char(10),
	@TimeLimited smallint,
	@UserIP varchar(25)
)
AS
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
--IF (SELECT count(PhoneNo) FROM [tblBlockedPhones] WHERE PhoneNo = @Original_PhoneNo) >0 
--	BEGIN
--		RETURN -1;
--	END
--ELSE
	--BEGIN
		UPDATE [tblBlockedPhones] SET [PhoneNo] = @PhoneNo, ReasonID=@ReasonID, [Descript]=@Descript, [Username] = @Username, [RequestID] = @RequestID, [TimeLimited]=@TimeLimited
		WHERE PhoneNo = @Original_PhoneNo;
		SET  @UserAction =  'Edit Blocked Phone: ' + @Original_PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,15,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ;  
		RETURN @@error;
	--END

