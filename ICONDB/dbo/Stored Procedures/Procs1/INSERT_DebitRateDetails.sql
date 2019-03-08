
CREATE PROCEDURE [dbo].[INSERT_DebitRateDetails]
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
--set IDENTITY_INSERT  tblDebitRate ON
	SET NOCOUNT OFF;
	Declare  @return_value int, @nextID int, @ID int, @tblDebitRate nvarchar(32) ;
    EXEC   @return_value = p_create_nextID 'tblDebitRate', @nextID   OUTPUT
    set           @ID = @nextID ;   
INSERT INTO [tblDebitRate] ([RecordID], [RatePlanID], [firstMin], [Nextmin], [ConnectFee], [SurchargeFee], [Calltype], [UserName],  [MinMinute],[Increment],[InputDate])
		VALUES 
		(@ID, @RatePlanID, @firstMin, @NextMin, @ConnectFee, @SurchargeFee, @Calltype, @userName, @MinMinute, @Increment, GETDATE());

SELECT RecordID, RatePlanID, firstMin, Nextmin, ConnectFee, SurchargeFee, Calltype, UserName, InputDate ,ModifyDate, MinMinute,Increment
               FROM tblDebitRate 

