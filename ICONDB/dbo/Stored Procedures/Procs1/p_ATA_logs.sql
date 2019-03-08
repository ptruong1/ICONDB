-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_ATA_logs]
@FacilityID int,
@FromDate datetime,
@ToDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	SELECT a.Location as FacilityLocation, b.ATALocation, c.PingTime LastCheck, c.ResonseTime as ResponseTime, (CASE c.Status when 1 then 'Active' Else 'Inactive' end) [Status]
	  from tblFacility a with(nolock) , tblFacilityATAInfo b with(nolock) , tblATAstatusDetail c with(nolock)  Where a.FacilityID = b.FacilityID and b.ATAIP = c.ATAIP
	  and c.PingTime between @FromDate and @ToDate and a.FacilityID= @FacilityID;
END

