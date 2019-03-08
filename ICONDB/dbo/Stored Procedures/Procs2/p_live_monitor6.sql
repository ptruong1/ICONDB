CREATE PROCEDURE [dbo].[p_live_monitor6]
@facilityID	int,
@DivisionID       int,
@locationID	int,
@stationID	varchar(30)
AS

If(@stationID <> '')

	select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
	 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel, ANINo,
	( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP,
	( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress,
	( select X.FirstName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN  and facilityID = @facilityID ) FirstName,
	( select X.LastName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN and facilityID = @facilityID ) LastName,
	(CASE  Channel when 1 then  'LINE01' 
		            when 2 then  'LINE02' 
			when 3 then  'LINE03' 
			when 4 then  'LINE04' 
			when 5 then  'LINE05' 
			when 6 then  'LINE06' 
			when 7 then  'LINE07' 
			when 8 then  'LINE08' 
			when 9 then  'LINE09' 
			ELSE 'LINE' + CAST (channel as char(2))
	END) Line , O.folderDate 
	
	From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo  AND A.facilityID =O.FacilityID) 
	WHERE 
		 A.FacilityID = @facilityID  AND  
		A.StationID =@stationID AND 
		O.Errorcode ='0' AND
		O.Duration is Null AND 
		O.Billtype < '12'  AND
		O.RecordFile <> 'NA' AND
		datediff(hh,O.recorddate,getdate()) <2 
		
	Order by status
Else
 Begin
	If (@locationID	> 0 )
	select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
	 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel,  ANINo,
	( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP,
	( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress,
	( select X.FirstName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN  and facilityID = @facilityID) FirstName,
	( select X.LastName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN  and facilityID = @facilityID) LastName,
	(CASE  Channel when 1 then  'LINE01' 
		            when 2 then  'LINE02' 
			when 3 then  'LINE03' 
			when 4 then  'LINE04' 
			when 5 then  'LINE05' 
			when 6 then  'LINE06' 
			when 7 then  'LINE07' 
			when 8 then  'LINE08' 
			when 9 then  'LINE09' 
			ELSE 'LINE' + CAST (channel as char(2))
	END) Line , O.folderDate 
	
	From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo  AND A.facilityID =O.FacilityID) 
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
			select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel,  ANINo,
	( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP,
	( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress,
	( select X.FirstName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN  and facilityID = @facilityID) FirstName,
	( select X.LastName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN  and facilityID = @facilityID) LastName,
			(CASE  Channel when 1 then  'LINE01' 
		            when 2 then  'LINE02' 
			when 3 then  'LINE03' 
			when 4 then  'LINE04' 
			when 5 then  'LINE05' 
			when 6 then  'LINE06' 
			when 7 then  'LINE07' 
			when 8 then  'LINE08' 
			when 9 then  'LINE09' 
			ELSE 'LINE' + CAST (channel as char(2))
			END) Line , O.folderDate 
			
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo  AND A.facilityID =O.FacilityID)  
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
			select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel,  ANINo,
	( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP,
	( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress,
	( select X.FirstName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN  and facilityID = @facilityID) FirstName,
	( select X.LastName from tblInmate X  with(nolock)  where O.inmateID = X.InmateID and O.PIN=X.PIN  and facilityID = @facilityID) LastName,
			(CASE  Channel when 1 then  'LINE01' 
				            when 2 then  'LINE02' 
					when 3 then  'LINE03' 
					when 4 then  'LINE04' 
					when 5 then  'LINE05' 
					when 6 then  'LINE06' 
					when 7 then  'LINE07' 
					when 8 then  'LINE08' 
					when 9 then  'LINE09' 
					ELSE 'LINE' + CAST (channel as char(2))
			END) Line , O.folderDate 
			
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo  AND A.facilityID =O.FacilityID)  
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