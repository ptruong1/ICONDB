
CREATE PROCEDURE p_live_monitor2A
@facilityID	int,
@DivisionID       int,
@locationID	int,
@stationID	varchar(30)
AS

If(@stationID <> '')

	select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(O.PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState, Channel, O.username, 
			
			( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) FirstName,
			( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) LastName
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
	WHERE 
		 A.FacilityID = @facilityID  AND  
		 A.StationID =@stationID AND 
		O.Errorcode ='0' AND
		O.Duration is Null AND 
		O.Billtype < '12'  AND
		O.RecordFile <> 'NA' AND
		datediff(hh,O.recorddate,getdate()) <2 
	
	
	order by status
Else
 Begin
	If (@locationID	> 0 )
		select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(O.PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState, Channel, O.username, 
			
			( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) FirstName,
			( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) LastName
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
		WHERE 
			 A.FacilityID = @facilityID  AND  
			 A.LocationID =@locationID AND 
			O.Errorcode ='0' AND
			O.Duration is Null AND 
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate,getdate()) <2 
			
	Order by status
	else
	   begin
		If (@DivisionID	> 0 )
			select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(O.PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState, Channel, O.username, 
			
			( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) FirstName,
			( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) LastName
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
		WHERE
			 A.FacilityID = @facilityID  AND  
			 A.DivisionID =@DivisionID AND
			O.Errorcode ='0' AND
			O.Duration is Null AND 
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate,getdate()) <2 
		
	
	Order by status
		Else
			select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(O.PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState, Channel, O.username, 
			
			( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) FirstName,
			( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and facilityID = @facilityID) LastName
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
		WHERE 
			 A.FacilityID = @facilityID  AND  
			 
			O.Errorcode ='0' AND
			O.Duration is Null AND 
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate,getdate()) <2 
			
	Order by status
	  end
 End