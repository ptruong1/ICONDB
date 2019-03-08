CREATE proc p_get_request_records(@FacilityID int, @InmateID varchar(250))
as
Begin
	BEGIN TRY  
		-- RequestStatus  2: Accept ; 3: Deny
		select  'Row#' = ROW_NUMBER() OVER(ORDER BY a.RequestDate  DESC),'Request Date' = a.RequestDate, 
		'Visitor Name' =b.VFirstName +space(1)+ b.VMi+ space(1) + b.VLastName,
		'Request Status' = dbo.GetRequestStatus(a.RequestStatus)
		from tblvisitRequest a, tblVisitors b
		where a.FacilityID=@FacilityID and a.InmateID=@InmateID and a.VisitorID=b.VisitorID
	END TRY  
	BEGIN CATCH    
	END CATCH  
End