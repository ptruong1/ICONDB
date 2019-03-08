


CREATE PROCEDURE [dbo].[INSERT_ANIs]
(
	@FacilityID int,
	@DivisionID int,
	@LocationID int,
	@ANINo char(10),
	@StationID varchar(50),
	@AccessTypeID tinyint,
	@IDrequired bit,
	@PINRequired bit,
	@DayTimeRestrict bit,
	@UserName varchar(25)
)
AS
	SET NOCOUNT OFF;

	Declare  @return_value int, @nextID int, @ID int, @tblANIs nvarchar(32) ;
IF @ANINo in (SELECT ANINo FROM tblANIs WHERE FacilityID = @FacilityID)
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
	    EXEC   @return_value = p_create_nextID 'tblANIs', @nextID   OUTPUT
        set           @ID = @nextID ;  
		INSERT INTO [tblANIs] ([PhoneID] ,[FacilityID], [DivisionID], [LocationID], [ANINo], [StationID], [AccessTypeID], [IDrequired], [PINRequired], [DayTimeRestrict], [UserName], [modifyDate]) 
			VALUES (@ID, @FacilityID, @DivisionID, @LocationID, @ANINo, @StationID, @AccessTypeID, @IDrequired, @PINRequired, @DayTimeRestrict, @UserName, getdate());
		RETURN 0;
	END


--IF @ANINo in (SELECT ANINo FROM tblANIs WHERE FacilityID = @FacilityID)
--	BEGIN
--		RETURN -1;
--	END
--ELSE
--	BEGIN
--		INSERT INTO [tblANIs] ([FacilityID], [DivisionID], [LocationID], [ANINo], [StationID], [AccessTypeID], [IDrequired], [PINRequired], [DayTimeRestrict], [UserName], [modifyDate]) VALUES (@FacilityID, @DivisionID, @LocationID, @ANINo, @StationID, @AccessTypeID, @IDrequired, @PINRequired, @DayTimeRestrict, @UserName, getdate());
--		RETURN 0;
--	END




