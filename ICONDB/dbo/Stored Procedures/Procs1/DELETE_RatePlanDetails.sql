
CREATE PROCEDURE [dbo].[DELETE_RatePlanDetails]
(
	@Original_RateID varchar(5),
	@Original_Mileagecode int,
	@Original_DayCode varchar(2),
	@Original_PointID varchar(2),
	@Original_TYPE char(1)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblRatePlanDetail] WHERE (([RateID] = @Original_RateID) AND ([Mileagecode] = @Original_Mileagecode) AND ([DayCode] = @Original_DayCode) AND ([PointID] = @Original_PointID) AND ([TYPE] = @Original_TYPE))

