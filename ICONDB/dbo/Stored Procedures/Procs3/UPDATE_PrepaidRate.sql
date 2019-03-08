
CREATE PROCEDURE [dbo].[UPDATE_PrepaidRate]
(
		@RateID varchar(5),
	@Descript varchar(50),
	@userName varchar(25)
	
)
AS
	SET NOCOUNT OFF;
UPDATE [tblRatePlan] SET  [Descript] = @Descript, [userName] = @userName WHERE (([RateID] = @RateID));
	
SELECT RateID, Descript, userName FROM tblRatePlan WHERE (RateID = @RateID)

