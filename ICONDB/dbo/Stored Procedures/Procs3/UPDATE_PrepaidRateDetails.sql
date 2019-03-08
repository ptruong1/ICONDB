
CREATE PROCEDURE [dbo].[UPDATE_PrepaidRateDetails]
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
	@Increment tinyint,
	@DayCode tinyint,
	@PointID varchar(2)

		
)
AS
--set IDENTITY_INSERT  tblPrepaidRate ON
	SET NOCOUNT OFF;
UPDATE [tblPrepaidRate] SET [RatePlanID] = @RatePlanID,[firstMin] = @firstMin, [NextMin] = @NextMin, [ConnectFee] = @ConnectFee, [SurchargeFee] = @SurchargeFee, [Calltype]=@Calltype,
							[UserName] = @userName, [InputDate] = GETDATE(), [ModifyDate] = GETDATE(), [MinMinute] = @MinMinute, [Increment] = @Increment, [DayCode] = @DayCode, [PointID] = @PointID

               WHERE [RatePlanID] = @RatePlanID and [RecordID] = @RecordID


SELECT RecordID, RatePlanID, firstMin, Nextmin, ConnectFee, SurchargeFee, Calltype, UserName, InputDate ,ModifyDate, MinMinute,Increment, DayCode, PointID
               FROM tblPrepaidRate 
				 WHERE [RatePlanID] = @RatePlanID and [RecordID] = @RecordID


