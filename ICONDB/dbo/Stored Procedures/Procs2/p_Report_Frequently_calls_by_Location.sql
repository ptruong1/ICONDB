

CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_Location]
@LocationID	int,
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS

If(@LocationID> 0 )
	Select    tblFacilityLocation.Descript as Location,   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.Descript as Calltype,  tblbilltype.Descript  as   BilledType 
		,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock), tblFacilityLocation with(nolock), tblANIs with(nolock) , tblCalltype with(nolock) ,  tblbilltype with(nolock) 
		  where tblcallsBilled.FromNo =  tblANIs.ANIno and  tblANIs.LocationID = tblFacilityLocation.LocationID and   tblCalltype.Abrev =  tblcallsBilled.Calltype and   tblbilltype.billtype = tblcallsbilled.billtype and
		   RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  and   tblFacilityLocation.LocationID = @LocationID
		 Order by tblFacilityLocation.Descript,RecordDate


Else
       	Select    tblFacilityLocation.Descript as Location,   fromNo , toNo,  RecordDate as  ConnectDateTime  , tblCalltype.Descript as Calltype,  tblbilltype.Descript   as   BilledType 
		,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock), tblFacilityLocation with(nolock), tblANIs with(nolock), tblCalltype, tblbilltype with(nolock)
		  where tblcallsBilled.FromNo =  tblANIs.ANIno and  tblANIs.LocationID = tblFacilityLocation.LocationID and   tblCalltype.Abrev =  tblcallsBilled.Calltype and   tblbilltype.billtype = tblcallsbilled.billtype and
		   RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  and  tblANIs.FacilityId = 0
		 Order by tblFacilityLocation.Descript,RecordDate

