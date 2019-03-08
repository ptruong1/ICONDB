

CREATE PROCEDURE [dbo].[UPDATE_ANIById]
(	
	@FacilityID int,
	@DivisionID int,
	@LocationID int,
	@ANINo char(10),
	@StationID varchar(25),
	@AccessTypeID tinyint,
	@IDrequired bit,
	@PINRequired bit,
	@DayTimeRestrict bit,
	@UserName varchar(25)
)
AS

SET NOCOUNT OFF;
UPDATE [tblANIs] SET [FacilityID] = @FacilityID, 
		[DivisionID] = @DivisionID,
		[LocationID] = @LocationID,
		[StationID] = @StationID, 
		[AccessTypeID] = @AccessTypeID, 
		[IDrequired] = @IDrequired, 
		[PINRequired] = @PINRequired, 
		[modifyDate] = getdate(), 
		[DayTimeRestrict] = @DayTimeRestrict, 
		[UserName] = @UserName WHERE [ANINo] = @ANINo;




