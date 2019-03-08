
CREATE PROCEDURE [dbo].[SELECT_InmateTimeRestrictByPin1]
(
	@PIN varchar(12)
)
AS
	SET NOCOUNT ON;
SELECT        PIN, days, hours, userName, modifydate
FROM            tblPINTimeCall  with(nolock)
WHERE       (PIN = @PIN)

