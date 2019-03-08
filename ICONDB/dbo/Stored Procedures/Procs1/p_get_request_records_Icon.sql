CREATE proc [dbo].[p_get_request_records_Icon]
(@FacilityID int)
as
Begin
	 
		-- RequestStatus  2: Accept ; 3: Deny
		select  a.RequestID, a.InmateID, (I.firstName + ' '  + I.LastName) as InmateName,
		a.RequestDate, 
		(b.VFirstName +space(1)+ b.VMi+ space(1) + b.VLastName) as VisitorName,
		R.Descript as RequestStatus
		from tblvisitRequest a, tblVisitors b, tblInmate I, tblRequestStatus R
		where a.FacilityID=@facilityID and a.VisitorID=b.VisitorID
		and I.facilityID = a.facilityID and I.inmateID = a.InmateID
		and a.requeststatus = R.RequestStatus 
	
End