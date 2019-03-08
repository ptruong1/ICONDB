


CREATE PROCEDURE [dbo].[SELECT_DebitRateDetails]
(
	@RatePlanID varchar(5)
)

AS
	SET NOCOUNT ON;
SELECT distinct        A.RecordID, RatePlanID, firstMin, NextMin, ConnectFee, SurchargeFee,A.Calltype, A.UserName, A.InputDate, ModifyDate, MinMinute, Increment 
 
 FROM            tblDeBitRate A Left JOIN tblCallType B ON A.Calltype = B.CallType
				 left Join tblRatePlan D ON A.RatePlanID  = D.RateID                      

WHERE RatePlanID = @RatePlanID  

