CREATE PROCEDURE [dbo].[p_Report_Flat_Revenue] 
(
	@AgentID	int,
	@DivisionID	int
)
AS
	SET NOCOUNT ON;
	
	If @DivisionID < 0

	Select X.Location, X.ANINo, (X.MostRecentServiceMonth) as LastTraffic, isNull(DATEDIFF(day, X.MostRecentServiceMonth, GETDATE()),'0') AS DaysSinceActivity,
	Status = CASE IsNull(X.MostRecentServiceMonth,0) WHEN 0 THEN 'Phone is not active in last 6 months' ELSE '' END

		From

		(SELECT Location, tblANIs.ANINo as ANINo,
		(select MAX(RecordDate)  from tblCallsBilled where tblANIs.ANiNo = tblCallsBilled.FromNo)  AS "MostRecentServiceMonth"
		 FROM tblANIs INNER JOIN tblFacility ON tblANIs.facilityID = tblFacility.FacilityID 
		where tblFacility.AgentID = @AgentID and tblFacility.status=1 ) as X
		
		Group by X.Location, X.ANINo, x.MostRecentServiceMonth
		Order by X.Location, X.ANINo, x.MostRecentServiceMonth

	else

		Select X.Location, X.ANINo, (X.MostRecentServiceMonth) as LastTraffic, isNull(DATEDIFF(day, X.MostRecentServiceMonth, GETDATE()),'0') AS DaysSinceActivity,
		Status = CASE IsNull(X.MostRecentServiceMonth,0) WHEN 0 THEN 'Phone is not active in last 6 months' ELSE '' END
		From

		(SELECT Location, tblANIs.ANINo as ANINo,
		(select MAX(RecordDate)  from tblCallsBilled where tblANIs.ANiNo = tblCallsBilled.FromNo)  AS "MostRecentServiceMonth"
		 FROM tblANIs INNER JOIN tblFacility ON tblANIs.facilityID = tblFacility.FacilityID 
		where tblFacility.AgentID = @AgentID and tblFacility.FacilityID=@DivisionID and tblFacility.status=1) as X
		
		Group by X.Location, X.ANINo, x.MostRecentServiceMonth
		Order by X.Location, X.ANINo, x.MostRecentServiceMonth
