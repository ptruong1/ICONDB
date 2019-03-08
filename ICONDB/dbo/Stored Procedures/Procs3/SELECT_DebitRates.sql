CREATE PROCEDURE [dbo].[SELECT_DebitRates]

AS
SELECT        RateID, Descript, userName, inputdate
FROM		tblRatePlan
--FROM           tblDebitRate A INNER JOIN tblRatePlan D ON A.RatePlanID  = D.RateID

/*ORDER BY RecordID*/

