

CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_ANI]
@facilityID	int,
@FromNo	varchar(10),
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS
SET @FromNo = isnull(@FromNo,'')
If( @FromNo <>'' )
	Select   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.Descript as Calltype, tblbilltype.Descript   as   BilledType 
		,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock), tblCalltype with(nolock) ,  tblbilltype with(nolock)
		  where   tblCalltype.Abrev = tblcallsBilled.Calltype and fromNo =@FromNo and  tblbilltype.billtype = tblcallsbilled.billtype and
		  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  and tblcallsBilled.FacilityId= @facilityID 
		 Order by RecordDate


Else
       	Select   fromNo , toNo,  RecordDate as  ConnectDateTime  , tblCalltype.Descript as Calltype, tblbilltype.Descript   as   BilledType 
		,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock), tblCalltype with(nolock), tblbilltype with(nolock)
		  where   tblCalltype.Abrev = tblcallsBilled.Calltype and  tblbilltype.billtype = tblcallsbilled.billtype and
		  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  and tblcallsBilled.FacilityId= @facilityID 
		 Order by FromNo,  RecordDate

