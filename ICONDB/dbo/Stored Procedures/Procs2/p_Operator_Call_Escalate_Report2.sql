
CREATE PROCEDURE [dbo].[p_Operator_Call_Escalate_Report2]
@fromDate	smalldatetime,
@toDate	smalldatetime,
@Status             int,
@AccountNo	varchar(12)
 AS

If @Status = -1
	begin
	If(@AccountNo	='') 
		select AdjID,Location,  AccountNo , AdjustDate, tblAdjustment.Descript as Descript, tblAdjustment.Status as StatusID, tblTroubleTicketStatus.Descript AS StatusDesc, tblAdjustment.userName as Username,
			(tblPrepaid.FirstName + ' ' + tblPrepaid.LastName) as ContactName, tblPrepaid.PhoneNo as ContactPhone, tblAdjustmentType.Descript as TypeDescript
		    from tblAdjustment with(nolock), tblPrepaid with(nolock) , tblFacility   with(nolock),  tblTroubleTicketStatus with(nolock), tblAdjustmentType with(nolock)
		 where   tblAdjustment.AccountNo =  tblPrepaid.PhoneNo  and 
	 		tblPrepaid.FacilityID = tblFacility.FacilityID And
			tblAdjustment.Status = tblTroubleTicketStatus.statusID And
			tblAdjustment.AdjTypeID = tblAdjustmentType.AdjTypeID and
		  	tblAdjustment. AdjTypeID =6 and AdjustDate between @fromDate and  dateadd(d,1, @toDate)
		Order by AdjustDate Desc
	else
		select AdjID,Location,  AccountNo , AdjustDate, tblAdjustment.Descript as Descript, tblAdjustment.Status as StatusID, tblTroubleTicketStatus.Descript AS StatusDesc, tblAdjustment.userName as Username,
			(tblPrepaid.FirstName + ' '+ tblPrepaid.LastName) as ContactName, tblPrepaid.PhoneNo as ContactPhone, tblAdjustmentType.Descript as TypeDescript
		    from tblAdjustment with(nolock), tblPrepaid with(nolock) , tblFacility   with(nolock),  tblTroubleTicketStatus with(nolock), tblAdjustmentType with(nolock)
		    
		 where   tblAdjustment.AccountNo =  tblPrepaid.PhoneNo  and 
	 		tblPrepaid.FacilityID = tblFacility.FacilityID And
			tblAdjustment.Status = tblTroubleTicketStatus.statusID And
			tblAdjustment.AdjTypeID = tblAdjustmentType.AdjTypeID and
		  	tblAdjustment. AdjTypeID =6 and AdjustDate between @fromDate and   dateadd(d,1, @toDate) and AccountNo = @AccountNo
		Order by AdjustDate Desc
	End
else
	begin
	If(@AccountNo	='') 
		select AdjID,Location,  AccountNo , AdjustDate, tblAdjustment.Descript as Descript, tblAdjustment.Status as StatusID, tblTroubleTicketStatus.Descript AS StatusDesc, tblAdjustment.userName as Username,
			(tblPrepaid.FirstName + ' '+ tblPrepaid.LastName) as ContactName, tblPrepaid.PhoneNo as ContactPhone, tblAdjustmentType.Descript as TypeDescript
		    from tblAdjustment with(nolock), tblPrepaid with(nolock) , tblFacility   with(nolock),  tblTroubleTicketStatus with(nolock), tblAdjustmentType with(nolock)
		 where   tblAdjustment.AccountNo =  tblPrepaid.PhoneNo  and 
	 		tblPrepaid.FacilityID = tblFacility.FacilityID And
			tblAdjustment.Status = tblTroubleTicketStatus.statusID And
			tblAdjustment.AdjTypeID = tblAdjustmentType.AdjTypeID and
		  	tblAdjustment. AdjTypeID =6 and AdjustDate between @fromDate and   dateadd(d,1, @toDate) and tblAdjustment.Status = @Status
			
		Order by AdjustDate Desc
	else
		select AdjID,Location,  AccountNo , AdjustDate, tblAdjustment.Descript as Descript, tblAdjustment.Status as StatusID, tblTroubleTicketStatus.Descript AS StatusDesc, tblAdjustment.userName as Username,
			(tblPrepaid.FirstName + ' ' + tblPrepaid.LastName) as ContactName, tblPrepaid.PhoneNo as ContactPhone, tblAdjustmentType.Descript as TypeDescript
		    from tblAdjustment with(nolock), tblPrepaid with(nolock) , tblFacility   with(nolock),  tblTroubleTicketStatus with(nolock), tblAdjustmentType with(nolock)
		    
		 where   tblAdjustment.AccountNo =  tblPrepaid.PhoneNo  and 
	 		tblPrepaid.FacilityID = tblFacility.FacilityID And
			tblAdjustment.Status = tblTroubleTicketStatus.statusID And
			tblAdjustment.AdjTypeID = tblAdjustmentType.AdjTypeID and
		  	tblAdjustment. AdjTypeID =6 and AdjustDate between @fromDate and   dateadd(d,1, @toDate) and AccountNo = @AccountNo
			and tblAdjustment.Status = @Status
		Order by AdjustDate Desc
	End

