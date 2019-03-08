CREATE PROCEDURE [dbo].[p_INSERT_NotPANByInmateID_07122018]
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
BEGIN
	SET NOCOUNT OFF;
	DECLARE @PANCount int;
	SELECT @PANCount = NotAllowLimit FROM tblInmate WHERE InmateID = @InmateID  and facilityID = @facilityID and Status=1	 ;

	IF (SELECT count(phoneNo) FROM tblPhones WHERE InmateID = @InmateID and facilityID = @facilityID and phoneNo = @PhoneNo ) >0  -- exist 
		RETURN -3 ;
	IF @PANCount <= (SELECT COUNT(*) FROM tblBlockedPhonesByPIN WHERE InmateID = @InmateID and facilityID = @facilityID)
		RETURN -2;
	IF @PhoneNo in (SELECT phoneNo FROM tblBlockedPhonesByPIN WHERE InmateID = @InmateID and facilityID = @facilityID)
		RETURN -1 ;
	ELSE
		BEGIN
			INSERT INTO [tblBlockedPhonesByPIN] ([phoneNo], [InmateID], [PIN], [ReasonID], [RequestID], [UserName], [InputDate],[TimeLimited], [DesCript],FacilityID) 
			VALUES  (@PhoneNo, @InmateID, @PIN, @ReasonID, @RequestID, @UserName,	@InputDate, @TimeLimited, @DesCript, @FacilityID) ;

			UPDATE [dbo].[tblInmate] SET  [PANNotAllow] = 1
				WHERE (InmateID = @InmateId AND [FacilityId] = @FacilityId) ;
	
			EXEC  INSERT_ActivityLogs1   @FacilityID,8, 0,	@userName,'', @PhoneNo;

			RETURN 0;
		END

END