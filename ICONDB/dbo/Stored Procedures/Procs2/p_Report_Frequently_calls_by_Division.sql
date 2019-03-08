

CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_Division]
@DivisionID	int,
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS

If(@DivisionID> 0 )
	Select    tblFacilityDivision.DepartmentName as Division,   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.Descript as Calltype, tblbilltype.Descript    as   BilledType 
		,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock), tblFacilityDivision with(nolock), tblANIs with(nolock), tblCalltype with(nolock) , tblbilltype with(nolock)
		  where tblcallsBilled.FromNo =  tblANIs.ANIno and  tblANIs.DivisionID = tblFacilityDivision.DivisionID and   tblCalltype.Abrev =  tblcallsBilled.Calltype and  tblbilltype.billtype = tblcallsbilled.billtype and
		   RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate  and    tblFacilityDivision.DivisionID = @DivisionID
		 Order by  tblFacilityDivision.DepartmentName,RecordDate



Else
       		Select    tblFacilityDivision.DepartmentName as Division,   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.Descript as Calltype, tblbilltype.Descript    as   BilledType 
		,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock), tblFacilityDivision with(nolock), tblANIs with(nolock) , tblCalltype with(nolock)  , tblbilltype with(nolock) 
		  where tblcallsBilled.FromNo =  tblANIs.ANIno and  tblANIs.DivisionID = tblFacilityDivision.DivisionID and  tblCalltype.Abrev =  tblcallsBilled.Calltype and   tblbilltype.billtype = tblcallsbilled.billtype and
		   RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate    and  tblFacilityDivision.FacilityID = 0
		 Order by  tblFacilityDivision.DepartmentName,RecordDate

