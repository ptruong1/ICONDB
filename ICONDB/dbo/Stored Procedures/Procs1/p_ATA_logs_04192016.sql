-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_ATA_logs_04192016]
@FacilityID int,
@FromDate datetime,
@ToDate datetime,
@AgentID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;  
	if (@facilityID > 0 )
		SELECT a.Location as FacilityLocation, b.ATALocation, c.PingTime as LastCheck, c.ResonseTime as ResponseTime, d.Descript as Status
		  from tblFacility a with(nolock) , tblFacilityATAInfo b with(nolock) , tblATAstatusDetail c with(nolock), tblATAStatus d with(nolock) 
		  Where a.FacilityID = b.FacilityID and b.ATAIP = c.ATAIP and c.Status =d.StatusID
		  and c.PingTime between @FromDate and dateadd(d,1,@ToDate) and a.FacilityID= @FacilityID
		  order by lastcheck desc
	  else
		SELECT a.Location as FacilityLocation, b.ATALocation, c.PingTime as LastCheck, c.ResonseTime as ResponseTime, d.Descript as Status
		  from tblFacility a with(nolock) , tblFacilityATAInfo b with(nolock) , tblATAstatusDetail c with(nolock), tblATAStatus d with(nolock)  
		   Where a.FacilityID = b.FacilityID and b.ATAIP = c.ATAIP and c.Status =d.StatusID
		  and c.PingTime between @FromDate and dateadd(d,1,@ToDate) and a.FacilityID in (select c.FacilityID from tblfacility c where c.AgentID=@AgentID)
	 order by LastCheck desc
--order by  PingTime desc
END
 
