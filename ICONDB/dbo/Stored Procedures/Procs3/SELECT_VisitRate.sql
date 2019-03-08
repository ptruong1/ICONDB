
CREATE PROCEDURE [dbo].[SELECT_VisitRate]
(
@RateID int
)
AS
	SET NOCOUNT ON;
SELECT        F.FacilityId as RateID
	  ,V.Descript
      ,isnull(PerMinCharge,0) as PerMinCharge
      ,isnull(ConnectFee,0) as ConnectFee
      ,isnull(VisitType,0) as visitOpt
      ,isnull(Increment,0) as Increment
      ,isnull(CommRate,0) as CommRate
FROM      [leg_Icon].[dbo].[tblFacility] F
left join   [leg_Icon].[dbo].[tblVisitRate] V with(nolock) on F.FacilityID = V.rateID
where F.facilityID = @RateID

