CREATE PROCEDURE [dbo].[INSERT_NotPANByInmateID]
(
	@PhoneNo varchar(10),
	@InmateID varchar(12),
	@PIN varchar(12),
	@ReasonID tinyint,
	@RequestID tinyint,
	@UserName varchar(25),
	@InputDate Datetime,
	@TimeLimited integer,
	@Descript varchar(200),
	@facilityID	int

)
AS
	SET NOCOUNT OFF;
	DECLARE @PANCount int;
SELECT @PANCount = NotAllowLimit FROM tblInmate WHERE InmateID = @InmateID  and facilityID = @facilityID	 ;
IF @PANCount <= (SELECT COUNT(*) FROM tblBlockedPhonesByPIN WHERE InmateID = @InmateID and facilityID = @facilityID)
	RETURN -2;
IF @PhoneNo in (SELECT phoneNo FROM tblBlockedPhonesByPIN WHERE InmateID = @InmateID and facilityID = @facilityID)
	RETURN -1 ;
ELSE
	BEGIN
		INSERT INTO [tblBlockedPhonesByPIN]
		 ([phoneNo], [InmateID], [PIN], [ReasonID], [RequestID], [UserName], [InputDate],[TimeLimited], [DesCript],FacilityID) 
		VALUES 
		 (@PhoneNo, @InmateID, @PIN, @ReasonID, @RequestID, @UserName,	@InputDate, @TimeLimited,
		 @DesCript, @FacilityID)

		EXEC  INSERT_ActivityLogs1   @FacilityID,8, 0,	@userName,'', @PhoneNo

		RETURN 0;
	END
