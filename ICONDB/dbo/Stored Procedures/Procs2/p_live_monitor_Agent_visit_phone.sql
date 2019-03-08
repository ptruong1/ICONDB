-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_live_monitor_Agent_visit_phone]
@AgentID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @timezone smallint;
	--SET @timezone =0;
 --   select @timezone = timezone from tblfacility with(nolock) where facilityID= @facilityID;
	--select FacilityID, RecordID, Ext as StationID, RecordDate as VisitTime  from tblVisitPhoneOnline with(nolock) 
	--where FacilityID  in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)
	--and RecordOpt ='Y' and RecordDate > dateadd(MINUTE , -MaxDuration, getdate()) 

	Select Ext as [StationID],V.FacilityID, V.RecordOpt,[StationType], O.PIN, isnull(O.RecordID,' ') as RecordID,O.RecordDate as VisitTime
  FROM [leg_Icon].[dbo].[tblVisitPhone] V
  left join tblVisitPhoneOnline O with(nolock) on V.ExtID = O.Ext and O.RecordOpt ='Y' and O.RecordDate > dateadd(MINUTE , -MaxDuration, getdate())
  where V.FacilityID  in (select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1)
  and V.StationType=3 and V.status = 1
  order by recordID desc
END

