-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_PrepaidRates]


AS
SELECT        RateID, Descript, userName,InputDate
FROM			tblRatePlan
--FROM          tblPrepaidRate A INNER JOIN tblRatePlan D ON A.RatePlanID  = D.RateID


