
CREATE PROCEDURE [dbo].[p_get_ATA_IP]
 AS
SET nocount on
select   tblFacility.Location  ,ATAIP,  tblFacilityATAInfo.Status,  tblFacilityATAInfo.Status as FailsCount,  AlertEmails 
from tblFacilityATAInfo with(nolock) , tblAlert with(nolock) , tblFacility with(nolock) 
where tblFacilityATAInfo.AlertID = tblAlert.AlertID and 
	tblFacility.FacilityID = tblFacilityATAInfo.FacilityID  AND  ATAIP <> 'ANALOG'  and tblFacilityATAInfo.status <3

UNION
select ComputerName , IpAddress, [status] ,3 , '7147158465@vtext.com;ptruong@legacyinmate.com,5625727936@vtext.com'  
from tblACPs with(nolock) where [status]=1;






