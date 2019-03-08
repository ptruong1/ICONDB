

CREATE PROCEDURE [dbo].[p_update_division_by_tablet]
(
	@CenterID int,
	@FacilityID int,
	@CenterName varchar(35),
	@PINRequired bit,
	@DayTimeRestrict bit,
	@userName varchar(25),
	@CenterStatus int
	

	
)
AS
	SET NOCOUNT OFF;
UPDATE [tblTabletCenter] SET [FacilityID] = @FacilityID, 
		[PINRequired] = @PINRequired, 
		[DayTimeRestrict] = @DayTimeRestrict,
		[userName] = @userName,
		[ModifyDate] = getdate(),
		[CenterStatus]  = @CenterStatus
		
		WHERE (([CenterID] = @CenterID));
	


