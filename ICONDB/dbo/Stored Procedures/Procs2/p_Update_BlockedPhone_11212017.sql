
CREATE PROCEDURE [dbo].[p_Update_BlockedPhone_11212017]
(
	@PhoneNo char(10),
	@FacilityID int,
	@GroupID int,
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
		UPDATE [tblBlockedPhones] SET [PhoneNo] = @PhoneNo, ReasonID=@ReasonID, [Descript]=@Descript, [Username] = @Username, [RequestID] = @RequestID, [TimeLimited]=@TimeLimited, [groupID]=@GroupID
		WHERE PhoneNo = @Original_PhoneNo and GroupID=@GroupID;
		SET  @UserAction =  'Edit Blocked Phone: ' + @Original_PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,15,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ;  
		RETURN @@error;
	--END

