
CREATE PROCEDURE [dbo].[DELETE_RatePlan]
(
	@Original_RateID varchar(5)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblRatePlan] WHERE (([RateID] = @Original_RateID))

