
CREATE PROCEDURE [dbo].[INSERT_PrepaidRate]
(
@RateID varchar(5),
	@Descript varchar(50),
	@userName varchar(25)
	
)
AS
SET NOCOUNT OFF;
Declare  @return_value int, @nextID int, @ID int, @tblRatePlan nvarchar(32) ;
 EXEC   @return_value = p_create_nextID 'tblRatePlan', @nextID   OUTPUT
    set           @ID = @nextID ;
INSERT INTO [tblRatePlan] ([RecordID], [RateID], [Descript], [userName], [inputDate]) VALUES (@ID, @RateID, @Descript, @userName, getdate());
	
SELECT RateID, Descript, userName FROM tblRatePlan WHERE (RateID = @RateID)

