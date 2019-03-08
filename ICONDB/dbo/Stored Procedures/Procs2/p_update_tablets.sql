

CREATE PROCEDURE [dbo].[p_update_tablets]
(
	@FacilityID int,
	@CenterID int,
	@inputBy varchar(25),
	@TabletID varchar(15),
	@Status int
)
AS
	SET NOCOUNT OFF;
UPDATE [tblTablets] SET  
		[inputBy] = @inputBy, [ModifyDate] = getdate(),
		[Status]  = @Status
		
		WHERE (([TabletID] = @TabletID) and [FacilityID] = @FacilityID and CenterID = @CenterID);
	


