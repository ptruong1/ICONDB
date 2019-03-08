
CREATE PROCEDURE [dbo].[p_Delete_blackout_date]
(
    @blackoutDate  Datetime,
	@UserID varchar(20),
	@FacilityID int,
	@UserIP varchar(25)
)
AS
SET NOCOUNT OFF;
Declare @UserAction varchar(200)

DELETE FROM tblholiday where FacilityID = @FacilityID and HolidayDate =@blackoutDate

Set @UserAction = 'Delete blackout date: ' 
EXEC  INSERT_ActivityLogs5   @FacilityID,50, @UserAction, @UserID, @UserIP


