-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_top_15_facility] 
	@timeZone smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 12  Location +', ' + [state] as Location  from tblFacility where 
	[status]=1 and AgentID not in (659,404,1169,1214)
	order by facilityID desc
END


