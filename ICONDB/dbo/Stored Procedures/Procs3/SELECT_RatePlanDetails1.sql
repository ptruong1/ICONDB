


CREATE PROCEDURE [dbo].[SELECT_RatePlanDetails1]
(
	@RateID varchar(5)
)

AS
	SET NOCOUNT ON;
SELECT distinct        RateID, A.Mileagecode,  D.Descript as [Rate Period], C.Descript as [Call Type], FirstMin, AddlMin, CollectCallFee as [Connect Fee],
                         MinDuration as [Minimun Duration],  MinIncrement as [Increment], UserName,  Inputdate,  ModifyDate
FROM            tblRatePlanDetail A INNER JOIN tblCallType C ON A.Type = C.CallType
				INNER JOIN tblDayCode D ON A.DayCode = D.DayCode
WHERE RateID = @RateID ORDER BY  D.Descript,  C.Descript
