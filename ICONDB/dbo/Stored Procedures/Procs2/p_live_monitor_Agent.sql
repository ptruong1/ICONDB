CREATE PROCEDURE [dbo].[p_live_monitor_Agent]
@AgentID int,
@DivisionID       int,
@locationID	int,
@stationID	varchar(30)
AS

If(@stationID <> '')

	SELECT O.facilityID, isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, 
StationID, 
isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel, ANINo
			 ,( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP
			 ,( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress
	,( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and  O.facilityID = X.facilityID)  FirstName
	,( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN   and  O.facilityID = X.facilityID)  LastName
  , (CASE  Channel when 1 then  'LINE01' 
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
  FROM [leg_Icon].[dbo].[tblOnCalls] O, tblANIs A With(nolock)

  where O.facilityID in (select facilityID from tblfacility where AgentID = @AgentID)
  and O.fromNo = A.ANINo and O.facilityID = A.facilityID
  and O.Errorcode ='0' AND
			O.Duration is Null AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate,getdate()) <2
			and A.StationID =@stationID
	Order by O.facilityID, status
Else
 Begin
	If (@locationID	> 0 )
	SELECT O.facilityID, isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, 
StationID, 
isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel, ANINo
			 ,( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP
			 ,( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress
	,( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and  O.facilityID = X.facilityID)  FirstName
	,( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN   and  O.facilityID = X.facilityID)  LastName
  , (CASE  Channel when 1 then  'LINE01' 
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
  FROM [leg_Icon].[dbo].[tblOnCalls] O, tblANIs A With(nolock)

  where O.facilityID in (select facilityID from tblfacility where AgentID = @AgentID)
  and O.fromNo = A.ANINo and O.facilityID = A.facilityID
  and O.Errorcode ='0' AND
			O.Duration is Null AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate,getdate()) <2
			And A.LocationID =@locationID
	Order by O.facilityID, status
	else
	   begin
		If (@DivisionID	> 0 )
			SELECT O.facilityID, isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, 
StationID, 
isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel, ANINo
			 ,( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP
			 ,( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress
	,( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and  O.facilityID = X.facilityID)  FirstName
	,( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN   and  O.facilityID = X.facilityID)  LastName
  , (CASE  Channel when 1 then  'LINE01' 
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
  FROM [leg_Icon].[dbo].[tblOnCalls] O, tblANIs A With(nolock)

  where O.facilityID in (select facilityID from tblfacility where AgentID = @AgentID)
  and O.fromNo = A.ANINo and O.facilityID = A.facilityID
  and O.Errorcode ='0' AND
			O.Duration is Null AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate,getdate()) <2
			And A.DivisionID =@DivisionID 
	Order by O.facilityID, status
		Else
			SELECT O.facilityID, isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, 
StationID, 
isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState,  Channel, ANINo
			 ,( select P.ComputerName from tblACPs P  with(nolock)  where O.UserName=P.IPAddress) ACP
			 ,( select P.IPAddress from tblACPs P  with(nolock)  where O.UserName=P.IPAddress)IPAddress
	,( select X.FirstName from tblInmate X  with(nolock)  where O.PIN=X.PIN  and  O.facilityID = X.facilityID)  FirstName
	,( select X.LastName from tblInmate X  with(nolock)  where O.PIN=X.PIN   and  O.facilityID = X.facilityID)  LastName
  , (CASE  Channel when 1 then  'LINE01' 
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
  FROM [leg_Icon].[dbo].[tblOnCalls] O, tblANIs A With(nolock)

  where O.facilityID in (select facilityID from tblfacility where AgentID = @AgentID)
  and O.fromNo = A.ANINo and O.facilityID = A.facilityID
  and O.Errorcode ='0' AND
			O.Duration is Null AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate,getdate()) <2
	Order by O.facilityID, status
	  end
 End
