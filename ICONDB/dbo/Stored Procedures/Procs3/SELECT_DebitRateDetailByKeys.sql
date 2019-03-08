
CREATE PROCEDURE [dbo].[SELECT_DebitRateDetailByKeys]
(
	@RatePlanID varchar(5),
	@CallType tinyint

)

AS
	SET NOCOUNT ON;
SELECT        RatePlanID, RecordID , firstMin , NextMin, ConnectFee, SurchargeFee, A.Calltype, UserName, InputDate, ModifyDate, MinMinute, Increment 
FROM            tblDebitRate A INNER JOIN tblCalltype B ON A.Calltype = B.CallType
WHERE RatePlanID = @RatePlanID and A.CallType =@CallType 
