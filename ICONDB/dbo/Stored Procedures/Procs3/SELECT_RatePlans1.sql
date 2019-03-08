
CREATE PROCEDURE [dbo].[SELECT_RatePlans1]

AS
SELECT        RateID, Descript, userName, inputdate
FROM            tblRatePlan

ORDER BY RateID

