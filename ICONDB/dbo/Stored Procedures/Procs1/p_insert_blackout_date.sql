
CREATE PROCEDURE [dbo].[p_insert_blackout_date]
(
	@blackoutDate  Datetime,
	@descript varchar (50),
	@UserID varchar(20),
	@FacilityID int,
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;

Declare @UserAction varchar(200);
	
IF (select COUNT(FacilityID ) from [tblholiday] with(nolock)
	 Where FacilityID=@FacilityID  and HolidayDate=@blackoutDate)>0
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		INSERT INTO tblholiday (FacilityID, HolidayDate, Descript, userName,  modifydate)
		VALUES (@FacilityID,@blackoutDate,@descript, @UserID, getdate());
	END
Set @UserAction = 'Insert User Groups ' 
EXEC  INSERT_ActivityLogs5   @FacilityID,52, @UserAction, @UserID, @UserIP


