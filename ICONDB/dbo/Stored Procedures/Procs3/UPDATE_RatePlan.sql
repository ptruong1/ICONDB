
CREATE PROCEDURE [dbo].[UPDATE_RatePlan]
(
	@RateID varchar(5),
	@Descript varchar(50),
	@userName varchar(25),
	@Original_RateID varchar(5)
)
AS
	SET NOCOUNT OFF;
UPDATE [tblRatePlan] SET [RateID] = @RateID, [Descript] = @Descript, [userName] = @userName WHERE (([RateID] = @Original_RateID));
	
SELECT RateID, Descript, userName FROM tblRatePlan WHERE (RateID = @RateID)

