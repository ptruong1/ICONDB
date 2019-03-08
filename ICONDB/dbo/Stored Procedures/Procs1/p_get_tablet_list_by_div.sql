-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_tablet_list_by_div]
	@facilityID int, 
	@DivisionID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select  a.TabletID, c.Descript as [Status] from tbltablets a, tblfacilitydivision b, tblTabletStatus  c 
		where a.facilityID = b.facilityID and a.DivisionID =b.DivisionID and a.Status = c.statusID and a.DivisionID = @DivisionID and a.FacilityID = @FacilityID ;

END
