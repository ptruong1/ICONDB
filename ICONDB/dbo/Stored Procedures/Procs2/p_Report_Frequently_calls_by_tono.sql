

CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_tono]
@facilityID	int,
@toNo	varchar(10),
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS
SET @toNo = isnull(@toNo,'')
IF ( @toNo <>'')
	Select   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.descript as Calltype,     tblbilltype .Descript as Billtype 
			,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock)  , tblCalltype with(nolock) , tblbilltype with(nolock)
			  where  tblCalltype.Abrev =  tblcallsBilled.Calltype 
				and  toNo =@toNo  and tblcallsBilled.FacilityId= @facilityID  
				and  tblbilltype.billtype = tblcallsBilled.billtype 
				 and  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate 
			 Order by  RecordDate

Else
	Select   fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.descript as Calltype,     tblbilltype .Descript as Billtype 
			,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock)  , tblCalltype with(nolock) , tblbilltype with(nolock)
			  where  tblCalltype.Abrev =  tblcallsBilled.Calltype 
				and  tblcallsBilled.FacilityId= @facilityID  
				and  tblbilltype.billtype = tblcallsBilled.billtype 
				 and  RecordDate > @fromDate and  convert(varchar(10), RecordDate ,101) <= @toDate 
			 Order by  RecordDate

