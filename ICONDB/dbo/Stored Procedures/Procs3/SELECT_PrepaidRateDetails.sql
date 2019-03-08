


CREATE PROCEDURE [dbo].[SELECT_PrepaidRateDetails]
(
	@RatePlanID varchar(5)
)

AS
	SET NOCOUNT ON;
SELECT distinct        A.RecordID, RatePlanID, firstMin, NextMin, ConnectFee, SurchargeFee,A.Calltype, A.UserName, A.InputDate, ModifyDate, MinMinute, Increment 
 
 FROM            tblPrepaidRate A Left JOIN tblCallType B ON A.Calltype = B.CallType
				Left JOIN tblDayCode C ON A.DayCode = C.DayCode left Join tblRatePlan D ON A.RatePlanID  = D.RateID                      

WHERE RatePlanID = @RatePlanID  

