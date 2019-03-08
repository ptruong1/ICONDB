
CREATE PROCEDURE [dbo].[INSERT_InmateTimeRestrict1_Old]
(
	@PIN char(12),
	@days tinyint,
	@hours bigint,
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;

Update tblInmate Set   DateTimeRestrict = 1 where PIN = @PIN
IF @days in (SELECT days FROM tblPintimecall  WHERE PIN = @PIN  AND days = @days)
	BEGIN
		UPDATE tblPintimecall  SET [hours] = @hours, [userName] = @userName, [modifydate] = @modifydate WHERE ((PIN = @PIN) AND ([days] = @days));
		RETURN;
	END
ELSE
	BEGIN
		INSERT INTO tblPintimecall   ([PIN], [days], [hours], [userName], [modifydate]) VALUES (@PIN, @days, @hours, @userName, @modifydate);
		RETURN;
	END

