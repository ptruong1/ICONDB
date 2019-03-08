
CREATE PROCEDURE [dbo].[INSERT_RatePlan]
(
	@RateID varchar(5),
	@Descript varchar(50),
	@userName varchar(25)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [tblRatePlan] ([RateID], [Descript], [userName]) VALUES (@RateID, @Descript, @userName);
	
SELECT RateID, Descript, userName FROM tblRatePlan WHERE (RateID = @RateID)

