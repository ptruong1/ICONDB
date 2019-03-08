
CREATE PROCEDURE [dbo].[SELECT_FacilitiesByState1]
( 
	@State varchar(2) 
)
AS
	SET NOCOUNT ON;

SELECT [FacilityID], [Location], [State] FROM tblFacility with(nolock) WHERE ([State] = @State ) and status = 1
Order by Location

