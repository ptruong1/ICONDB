
CREATE PROCEDURE [dbo].[INSERT_FacilityTimeRestrict]
(
	@FacilityID int,
	@days tinyint,
	@hours bigint,
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblFacility  Set   DayTimeRestrict = 1 where FacilityID = @FacilityID

--EXEC  INSERT_ActivityLogs1   @FacilityID,6, 0,	@userName,'', @FacilityID

IF @days in (SELECT days FROM [tblFacilityTimeCall] WHERE FacilityID = @FacilityID AND days = @days)
	BEGIN
		UPDATE [tblFacilityTimeCall] SET [hours] = @hours, [userName] = @userName, [modifydate] = @modifydate WHERE (([FacilityID] = @FacilityID) AND ([days] = @days));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO [tblFacilityTimeCall] ([FacilityID], [days], [hours], [userName], [modifydate]) VALUES (@FacilityID, @days, @hours, @userName, @modifydate);
		RETURN;
	END
