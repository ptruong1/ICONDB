
CREATE PROCEDURE [dbo].[p_Call_Live_Monitor]
@FacilityID	int,
@divisionID	int,
@locationID	int,
@StationID	varchar(10),
@PIN		varchar(12),
@callingCard	varchar(12),
@DNI		varchar(16),
@fromDate	smalldatetime,  -- Required 
@toDate	smalldatetime 

 AS

	
SET NOCOUNT ON

If(@divisionID =  0 ) 
 
begin
    If (@StationID <> '')
	begin
	If(@PIN <> '' and  @callingCard <> ''  and  @DNI <> '' ) 
	  Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND E.StationID = @StationID
		AND A.PIN = @Pin
		AND A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc

	 End

	Else If  @callingCard <> '' 
	 Begin
		
		 SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND E.StationID = @StationID
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 
	ORDER BY A.RecordDate Desc

	 End
	
	
	Else If(@PIN <> '' and @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND A.ToNo = @DNI
		AND E.StationID = @StationID
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc
	end

	Else If(@PIN <> '') 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND E.StationID = @StationID
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc
	end

	Else If( @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.ToNo = @DNI
		AND E.StationID = @StationID		

		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc
	end

	Else 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE  A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND E.StationID = @StationID
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID
		AND E.StationID = @StationID

	ORDER BY A.RecordDate Desc
	end
  end
	else 				
					--------StationID = ''
	begin
	If(@PIN <> '' and  @callingCard <> ''  and  @DNI <> '' ) 
	  Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND A.PIN = @Pin
		AND A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc

	 End

	Else If  @callingCard <> '' 
	 Begin
		
		 SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 
	ORDER BY A.RecordDate Desc

	 End
	
	
	Else If(@PIN <> '' and @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc
	end

	Else If(@PIN <> '') 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc
	end

	Else If( @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 

	ORDER BY A.RecordDate Desc
	end

	Else 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE  A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 
		AND A.FacilityID = @FacilityID
		
	ORDER BY A.RecordDate Desc
	end
  end
end	
else		-------divisionID <> ''
begin
     If(@LocationID > 0)
	begin
	If (@StationID <> '')  
	 begin
	If(@PIN <> '' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND E.StationID = @StationID
		AND A.PIN = @Pin
		AND A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID

	ORDER BY A.RecordDate Desc

	 End

	Else If @callingCard <> '' 
	 Begin
		
		 SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID
 
	ORDER BY A.RecordDate Desc

	 End

	
	Else If(@PIN <> '' and @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end

	Else If(@PIN <> '') 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end

	Else If( @DNI <> '' ) 
	 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.ToNo = @DNI		
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end

	Else
	 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.ToNo = @DNI		
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end

       end
	else 		------Station ID = ''
	 begin
	If(@PIN <> '' and  @callingCard <> ''  and  @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND A.PIN = @Pin
		AND A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'') 
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID

	ORDER BY A.RecordDate Desc

	 End

	Else If @callingCard <> '' 
	 Begin
		
		 SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE A.CreditcardNo = @Callingcard
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID
 
	ORDER BY A.RecordDate Desc

	 End

	
	Else If(@PIN <> '' and @DNI <> '' ) 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND A.ToNo = @DNI
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end

	Else If(@PIN <> '') 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.PIN = @Pin
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end

	Else If( @DNI <> '' ) 
	 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.ToNo = @DNI		
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.LocationID = @LocationID
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end

	Else
	 
	 Begin
		
		SELECT A.RecordID, A.FromNo, A.ToNo, A.FromState, A.ToState, A.FromCity, A.ToCity, A.PIN, A.RecordDate, 
			A.CreditcardNo, C.Descript as [BillTypeName], A.Duration, D.IPAddress,  D.ComputerName as [HostName], 
			A.Channel, A.FolderDate, A.RecordFile, E.DivisionID, E.LocationID, E.StationID 
		FROM tblOnCalls A 
		INNER JOIN tblBillType C on A.BillType = C.Billtype 
		INNER JOIN tblACPs D on A.userName = D.IPAddress 
		INNER JOIN tblANIs E on A.FromNo = E.ANINo  
	WHERE 	A.ToNo = @DNI		
		AND A.RecordDate >= @fromDate
		AND A.RecordDate <= @todate
		AND (A.RecordFile<>'NA') 
		AND (A.RecordFile<>'')
		AND E.DivisionID = @divisionID
		AND A.FacilityID = @FacilityID 

	ORDER BY A.RecordDate Desc
	end
      end
  end
end

