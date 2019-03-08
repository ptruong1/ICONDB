
CREATE PROCEDURE [dbo].[SELECT_PrepaidRateDetailByKeys]
(
	@RatePlanID varchar(5),
	@RecordID int
	
)

AS
	SET NOCOUNT ON;
SELECT        RatePlanID, RecordID , firstMin , NextMin, ConnectFee, SurchargeFee, Calltype, UserName, InputDate, ModifyDate, MinMinute, Increment, DayCode, PointID 
FROM            tblPrepaidRate
Where RatePlanID = @RatePlanID and RecordID = @RecordID
