



CREATE PROCEDURE [dbo].[UPDATE_NotPANByPhoneNo]
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
IF @PhoneNo in (SELECT phoneNo FROM tblBlockedPhonesByPIN WHERE InmateID = @InmateID AND PhoneNo <> @PhoneNo)
	BEGIN
		RETURN -1 ;
	END
ELSE
	BEGIN
		UPDATE [tblBlockedPhonesByPIN]
			 SET [phoneNo] = @PhoneNo,
			 [PIN]=@PIN,
			 [ReasonID]=@ReasonID,
			 [RequestID]=@RequestID,
			 [UserName]=@UserName,
			 [InputDate]=@InputDate,
			[TimeLimited]=@TimeLimited,
			 [Descript]=@Descript
			 WHERE
			 PhoneNo = @PhoneNo and
			 FacilityID = @FacilityID and
			 InmateID = @InmateID

		EXEC  INSERT_ActivityLogs1   @FacilityID,14, 0,	@UserName,'',   @InmateID
		RETURN 0;
	END
