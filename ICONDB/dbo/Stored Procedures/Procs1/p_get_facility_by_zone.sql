-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facility_by_zone] 
	@timeZone smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT state, facilityID, Location   from tblFacility with(nolock) where 
	timeZone=@timeZone and [status]=1 and AgentID <100
	order by [State], Location;
	
END


