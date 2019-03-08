


CREATE PROCEDURE [dbo].[SELECT_RatePlanDetails]
(
	@RateID varchar(5)
)

AS
	SET NOCOUNT ON;
SELECT distinct        RateID, A.Mileagecode, A.DayCode, D.Descript as [DayCodeName], A.PointID, A.TYPE, C.Descript as [CallTypeName], A.Description, FirstMin, AddlMin, CollectCallFee, CallingCardFee, CreditCardFee, ThirdPartyFee, PerToPerFee, 
                         ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, UserName, RateDetailID, Inputdate, 
                         ModifyDate
FROM            tblRatePlanDetail A INNER JOIN tblCallType C ON A.Type = C.CallType
				INNER JOIN tblDayCode D ON A.DayCode = D.DayCode
WHERE RateID = @RateID ORDER BY A.Type,A.Mileagecode
