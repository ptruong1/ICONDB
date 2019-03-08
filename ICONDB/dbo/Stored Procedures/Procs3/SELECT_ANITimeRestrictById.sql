
CREATE PROCEDURE [dbo].[SELECT_ANITimeRestrictById]
(
	@ANINo char(10)
)
AS
	SET NOCOUNT ON;
SELECT        ANI, days, hours, userName, modifydate
FROM            tblANITimeCall   with(nolock)
WHERE        (ANI = @ANINo)

