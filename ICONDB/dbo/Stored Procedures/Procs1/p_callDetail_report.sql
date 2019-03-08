
CREATE PROCEDURE [dbo].[p_callDetail_report]
@callDate char(6)
AS

select tblFacility.facilityID,Location ,fromNo,Tono,calldate,connecttime,Calltype,Billtype , Duration,PIN, CallRevenue from tblCallsbilled with(nolock), tblFacility with(nolock) where tblCallsbilled.FacilityID=tblFacility.facilityID and  calldate =@callDate
order by tblFacility.facilityID

