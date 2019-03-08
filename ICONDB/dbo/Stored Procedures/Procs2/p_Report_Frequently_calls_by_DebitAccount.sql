

CREATE PROCEDURE [dbo].[p_Report_Frequently_calls_by_DebitAccount]
@facilityID	int,
@AccountNo	varchar(10),
@fromDate	smalldatetime,
@toDate	smalldatetime
 AS
SET @AccountNo = isnull(@AccountNo,'')
IF(@AccountNo <>'')
	Select  		Billtono as AccountNo,  fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.Descript  as Calltype
			,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock) , tblCalltype with(nolock)
			  where   tblCalltype.Abrev = tblcallsBilled.Calltype and
			    billtono =@AccountNo  and   RecordDate > @fromDate and   convert(varchar(10), RecordDate ,101) <= @toDate  and tblcallsBilled.FacilityId= @facilityID  and billtype ='07'
			 Order by  RecordDate
Else
	Select  		Billtono as AccountNo,  fromNo , toNo,  RecordDate as  ConnectDateTime  ,  tblCalltype.Descript  as CallType
			,dbo.fn_ConvertSecToMin( duration) as Duration  from tblcallsBilled with(nolock) , tblCalltype with(nolock)
			  where   tblCalltype.Abrev = tblcallsBilled.Calltype and
			     RecordDate > @fromDate and   convert(varchar(10), RecordDate ,101) <= @toDate  and tblcallsBilled.FacilityId= @facilityID  and billtype ='07'
			 Order by  RecordDate

