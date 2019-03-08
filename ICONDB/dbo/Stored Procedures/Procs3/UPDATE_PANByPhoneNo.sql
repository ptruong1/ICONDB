



CREATE PROCEDURE [dbo].[UPDATE_PANByPhoneNo]
(	
	@PhoneNo varchar(10),
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
IF @PhoneNo in (SELECT phoneNo FROM tblBlockedPhonesByPIN WHERE PIN = @PIN AND PhoneNo <> @PhoneNo)
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
			 PIN = @PIN

		EXEC  INSERT_ActivityLogs1   @FacilityID,14, 0,	@UserName,'',   @PIN
		RETURN 0;
	END
