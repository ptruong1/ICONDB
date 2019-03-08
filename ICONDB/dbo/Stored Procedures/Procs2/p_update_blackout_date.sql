
CREATE PROCEDURE [dbo].[p_update_blackout_date]
(
	@currentBlackoutDate Datetime,
	@currentDescript varchar(50),
	@newBlackoutDate  Datetime,
	@newDescript  varchar(50),
	@UserID varchar(20),
	@FacilityID int,
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;

Declare @UserAction varchar(200);
	
IF (select COUNT(FacilityID ) from [tblholiday] with(nolock)
	 Where FacilityID=@FacilityID  and HolidayDate= @newBlackoutDate)>0
	BEGIN
		if @currentBlackoutDate =@newBlackoutDate
		begin
			update tblholiday set FacilityID =@FacilityID,
								  HolidayDate=@newBlackoutDate,
							      Descript=@newDescript,
							      userName =@UserID,
							      modifyDate =getdate()
						          where FacilityID=@FacilityID and HolidayDate=@currentBlackoutDate 	
		end	
		else
			RETURN -1;
	END
ELSE
	BEGIN
		update tblholiday set FacilityID =@FacilityID,
							   HolidayDate=@newBlackoutDate,
							   Descript=@newDescript,
							   userName =@UserID,
							   modifyDate =getdate()
        where FacilityID=@FacilityID and HolidayDate=@currentBlackoutDate 
    END
Set @UserAction = 'Update Blackout Dates ' 
EXEC  INSERT_ActivityLogs5   @FacilityID,49, @UserAction, @UserID, @UserIP


