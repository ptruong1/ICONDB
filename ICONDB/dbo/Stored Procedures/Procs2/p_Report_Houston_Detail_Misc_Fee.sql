CREATE PROCEDURE [dbo].[p_Report_Houston_Detail_Misc_Fee] 
(
	@facilityID	int,
	@fromDate	smalldatetime,
	@todate	smalldatetime
)
AS
	SET NOCOUNT ON;
	
	select tblfacility.facilityID, tblfacility.Location, tblfacility.Address,tblfacility.Zipcode,tblfacility.State, 
RecordDate as Date, fromno as ANI, tblANIs.StationID, tblFacilityLocation.Descript,  tono, tblcallsbilled.BillToNo, 0 as Fee   
	from tblcallsbilled with(nolock), tblfacility with(nolock),
		tblANIs with(nolock), tblFacilityLocation with(nolock) 
		
		 WHERE  		 tblcallsbilled.fromNo = tblANIs.ANINo and
						 tblANIs.LocationID = tblFacilityLocation.LocationID and
					 	tblcallsbilled.facilityID	= @facilityID  And
						tblfacility.facilityID = @facilityID and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	
						 
	Order by tblcallsbilled.fromno, tblcallsbilled.RecordDate
	 
