
CREATE PROCEDURE [dbo].[INSERT_LocationTimeRestrict]
(
	@LocationID int,
	@days tinyint,
	@hours bigint,
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblFacilityLocation Set   DayTimeRestrict = 1 where LocationID = @LocationID

IF @days in (SELECT days FROM tblLocationTimeCall  WHERE LocationID = @LocationID  AND days = @days)
	BEGIN
		UPDATE tblLocationTimeCall  SET [hours] = @hours, [userName] = @userName, [modifydate] = @modifydate WHERE ((LocationID = @LocationID) AND ([days] = @days));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO tblLocationTimeCall   ([LocationID], [days], [hours], [userName], [modifydate]) VALUES (@LocationID, @days, @hours, @userName, @modifydate);
		RETURN;
	END

