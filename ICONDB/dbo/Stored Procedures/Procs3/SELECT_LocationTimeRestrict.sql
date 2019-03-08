
CREATE PROCEDURE [dbo].[SELECT_LocationTimeRestrict]
(
	@LocationID int
)
AS
	SET NOCOUNT ON;
SELECT        LocationID, days, hours, userName, modifydate
FROM            tblLocationTimeCall  with(nolock)
WHERE       (LocationID = @LocationID)

