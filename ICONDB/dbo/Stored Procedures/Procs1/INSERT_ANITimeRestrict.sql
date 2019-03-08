
CREATE PROCEDURE [dbo].[INSERT_ANITimeRestrict]
(
	@ANINo char(10),
	@days tinyint,
	@hours bigint,
	@userName varchar(20),
	@modifydate smalldatetime
)
AS
	SET NOCOUNT OFF;

Update tblANIs Set   DayTimeRestrict = 1 where ANIno = @ANINo
IF @days in (SELECT days FROM [tblANITimeCall] WHERE ANI = @ANINo AND days = @days)
	BEGIN
		UPDATE [tblANITimeCall] SET [hours] = @hours, [userName] = @userName, [modifydate] = @modifydate WHERE ((ANI = @ANINo) AND ([days] = @days));
		
	END
ELSE
	BEGIN
		INSERT INTO [tblANITimeCall] ([ANI], [days], [hours], [userName], [modifydate]) VALUES (@ANINo, @days, @hours, @userName, @modifydate);
		
	END


RETURN;

