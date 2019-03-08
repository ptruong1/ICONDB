-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_tablet_list_by_div_v1]
	@facilityID int, 
	@TabletID char(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select  a.TabletID, c.StatusID as [Status] from tbltablets a, tblTabletCenter b, tblTabletStatus  c 
		where a.facilityID = b.facilityID and a.CenterID =b.CenterID and a.Status = c.statusID and TabletID = @TabletID and a.FacilityID = @FacilityID ;

END

