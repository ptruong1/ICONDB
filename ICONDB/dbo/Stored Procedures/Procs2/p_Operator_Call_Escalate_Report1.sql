
CREATE PROCEDURE [dbo].[p_Operator_Call_Escalate_Report1]
@fromDate	smalldatetime,
@toDate	smalldatetime,
@AccountNo	varchar(10)
 AS

If(@AccountNo	='') 
	select AdjID,Location,  AccountNo , AdjustDate, Descript    from tblAdjustment with(nolock), tblPrepaid with(nolock) , tblFacility   with(nolock)
	 where   tblAdjustment.AccountNo =  tblPrepaid.PhoneNo  and 
 		tblPrepaid.FacilityID = tblFacility.FacilityID And
	  	 AdjTypeID =6 and AdjustDate between @fromDate and  @toDate
else
	select AdjID,Location,  AccountNo , AdjustDate, Descript    from tblAdjustment with(nolock), tblPrepaid with(nolock) , tblFacility   with(nolock)
	 where   tblAdjustment.AccountNo =  tblPrepaid.PhoneNo  and 
 		tblPrepaid.FacilityID = tblFacility.FacilityID And
	  	 AdjTypeID =6 and AdjustDate between @fromDate and  @toDate and AccountNo = @AccountNo

