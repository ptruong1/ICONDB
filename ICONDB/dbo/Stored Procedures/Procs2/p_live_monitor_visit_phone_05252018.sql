-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[p_live_monitor_visit_phone_05252018]
@FacilityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @timezone smallint;
	SET @timezone =0;
    Select V.ExtID ,StationID,V.FacilityID, V.RecordOpt,[StationType], O.PIN, isnull(O.RecordID,' ') as RecordID,O.RecordDate as VisitTime
  FROM [leg_Icon].[dbo].[tblVisitPhone] V
  left join tblVisitPhoneOnline O with(nolock) on V.ExtID = O.Ext and O.RecordOpt ='Y' and O.RecordDate > dateadd(MINUTE , -MaxDuration, getdate())
  where V.facilityID = @facilityID
  and V.StationType=3 and V.status = 1
  order by recordID desc
END

