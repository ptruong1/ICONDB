
CREATE PROCEDURE [dbo].[SELECT_RatePlanDetailByKeys]
(
	@RateID varchar(5),
	@Mileagecode int,
	@DayCode int,
	@PointID varchar(2),
	@TYPE char(1)
)

AS
	SET NOCOUNT ON;
SELECT        RateID, A.Mileagecode, isnull(A.DayCode,0) as DayCode, D.Descript as [DayCodeName], A.PointID, A.TYPE, C.Descript as [CallTypeName], A.Description, FirstMin, AddlMin, CollectCallFee, CallingCardFee, CreditCardFee, ThirdPartyFee, PerToPerFee, 
                         ACPCollectCallFee, ACPCallingCardFee, ACPCreditCardFee, ACPDebitFee, MinDuration, MinDurationIntl, MinIncrement, UserName, RateDetailID, Inputdate, 
                         ModifyDate
FROM            tblRatePlanDetail A INNER JOIN tblCallType C ON A.Type = C.CallType
				INNER JOIN tblDayCode D ON A.DayCode = D.DayCode
WHERE   RateID = @RateID and
	  Mileagecode = @Mileagecode and
	 A.dayCode = @DayCode and
	  PointID = @PointID and
	  Type    = @TYPE
 
ORDER BY CallType,Mileagecode

