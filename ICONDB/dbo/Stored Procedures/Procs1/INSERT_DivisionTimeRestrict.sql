
CREATE PROCEDURE [dbo].[INSERT_DivisionTimeRestrict]
(
	@DivisionID int,
	@days tinyint,
	@hours bigint,
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;
Update tblFacilityDivision Set   DayTimeRestrict = 1 where DivisionID = @DivisionID;

IF @days in (SELECT days FROM tblDivisionTimeCall  WHERE DivisionID = @DivisionID  AND days = @days)
	BEGIN
		UPDATE tblDivisionTimeCall  SET [hours] = @hours, [userName] = @userName, [modifydate] = @modifydate WHERE ((DivisionID = @DivisionID) AND ([days] = @days));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO tblDivisionTimeCall   ([DivisionID], [days], [hours], [userName], [modifydate]) VALUES (@DivisionID, @days, @hours, @userName, @modifydate);
		RETURN;
	END

