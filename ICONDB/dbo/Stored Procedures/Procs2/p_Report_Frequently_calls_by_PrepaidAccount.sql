


CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_PrepaidAccount]
@facilityID	int,
@phoneNo	varchar(10),
@fromDate	smalldatetime,
@todate	smalldatetime

 AS
SET @phoneNo = isnull(@phoneNo,'')
IF (  @phoneNo <>'') 
	Select   toNo as AccountNo,	fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.descript as Calltype 
			,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock) , tblCalltype with(nolock)
			  where   tblCalltype.Abrev = tblcallsBilled.Calltype and
				toNo =@phoneNo  and  RecordDate > @fromDate	 and    convert(varchar(10), RecordDate ,101) <= @toDate and tblcallsBilled.FacilityId= @facilityID 
				and billtype ='10'
			 Order by  RecordDate

Else
	Select   toNo as AccountNo,	fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.descript as Calltype 
			,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock) , tblCalltype with(nolock)
			  where   tblCalltype.Abrev = tblcallsBilled.Calltype and
				 RecordDate > @fromDate	 and    convert(varchar(10), RecordDate ,101) <= @toDate and tblcallsBilled.FacilityId= @facilityID 
				and billtype ='10'
			 Order by  RecordDate

