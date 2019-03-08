
CREATE PROCEDURE [dbo].[UPDATE_DebitRateDetails]
(
	@RecordID int,
	@RatePlanID varchar(5),
	@firstMin numeric (4,2),
	@NextMin numeric (4,2),
	@ConnectFee numeric (4,2),
	@SurchargeFee numeric (4,2),
	@Calltype tinyint,
	@userName varchar(50),
	@MinMinute tinyint,
	@Increment tinyint
		
)
AS
	SET NOCOUNT OFF;
UPDATE [tblDebitRate] SET [RatePlanID] = @RatePlanID, [firstMin] = @firstMin, [NextMin] = @NextMin, [ConnectFee] = @ConnectFee, [SurchargeFee] = @SurchargeFee, [Calltype]=@Calltype,
							[UserName] = @userName, [InputDate] = GETDATE(), [ModifyDate] = GETDATE(), [MinMinute] = @MinMinute, [Increment] = @Increment

               WHERE ([RecordID] = @RecordID) AND ([Calltype] = @Calltype) AND ([RatePlanID] = @RatePlanID)
	
SELECT RecordID, RatePlanID, firstMin, NextMin, ConnectFee, SurchargeFee, Calltype, UserName, InputDate, ModifyDate, MinMinute, Increment
              FROM tblDebitRate 
              WHERE ([RecordID] = @RecordID) AND ([Calltype] = @Calltype)AND ([RatePlanID] = @RatePlanID) 


