
CREATE PROCEDURE [dbo].[SELECT_DivisionTimeRestrict]
(
	@DivisionID int
)
AS
	SET NOCOUNT ON;
SELECT        DivisionID, days, hours, userName, modifydate
FROM            tblDivisionTimeCall  with(nolock)
WHERE       (DivisionID = @DivisionID)

