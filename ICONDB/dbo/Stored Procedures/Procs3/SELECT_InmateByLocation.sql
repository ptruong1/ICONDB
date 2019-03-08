

CREATE PROCEDURE [dbo].[SELECT_InmateByLocation]
(@facilityID int)
AS
	SET NOCOUNT ON;
SELECT [LocationID]
       ,[Descript]
   
  FROM [leg_Icon].[dbo].[tblFacilityLocation] L
  inner join [leg_Icon].[dbo].[tblFacilitydivision] D on D.DivisionID = L.DivisionID
  where D.FacilityID = @facilityID 

