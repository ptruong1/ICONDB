
CREATE PROCEDURE [dbo].[INSERT_PrepaidRateDetails]
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
	SET NOCOUNT OFF;
	Declare  @return_value int, @nextID int, @ID int, @tblPrepaidRate nvarchar(32) ;
    EXEC   @return_value = p_create_nextID 'tblPrepaidRate', @nextID   OUTPUT
    set           @ID = @nextID 
INSERT INTO [tblPrepaidRate] ([RecordID], [RatePlanID], [firstMin], [Nextmin], [ConnectFee], [SurchargeFee], [Calltype], [UserName], [MinMinute],[Increment], [Daycode], [PointID], [InputDate] )
		VALUES 
		(@ID, @RatePlanID, @firstMin, @NextMin, @ConnectFee, @SurchargeFee, @Calltype, @userName,@MinMinute, @Increment, @DayCode, @PointID, Getdate());

SELECT RecordID, RatePlanID, firstMin, Nextmin, ConnectFee, SurchargeFee, Calltype, UserName, InputDate ,ModifyDate, MinMinute,Increment, DayCode, PointID
               FROM tblPrepaidRate 

