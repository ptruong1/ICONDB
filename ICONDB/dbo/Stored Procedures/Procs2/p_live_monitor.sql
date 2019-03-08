
CREATE PROCEDURE [dbo].[p_live_monitor]
@facilityID	int,
@DivisionID       int,
@locationID	int,
@stationID	varchar(30)
AS

Declare   @timeZone  tinyint,  @recordDate datetime ;
select  @timeZone  = timezone from tblfacility with(nolock)  where facilityID = @facilityID ;
Set  @recordDate = getdate();
set @recordDate = dateadd(hh, @timeZone, @recordDate) ;
If(@stationID <> '')
	select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
	 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState
	From tblANIs A With(nolock)  left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
	WHERE
	    	 
	      	 A.FacilityID = @facilityID AND  
		A.StationID =@stationID AND 
		O.Errorcode ='0' AND
		O.Duration is Null AND 
		O.Billtype < '12'  AND
		O.RecordFile <> 'NA' AND
		datediff(hh ,O.recorddate, @recordDate) <2 ;
Else
 Begin
	If (@locationID	> 0 )
		select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
		 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState
		From tblANIs A With(nolock) left outer join tblOncalls O with(nolock)  on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
		WHERE 
	      	 A.FacilityID = @facilityID  AND  
		A.LocationID =@locationID AND 
		O.Errorcode ='0' AND
		O.Duration is Null AND
		O.Billtype < '12'  AND
		O.RecordFile <> 'NA' AND
		datediff(hh,O.recorddate, @recordDate) <2 ;
	else
	   begin
		If (@DivisionID	> 0 )
			select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
			WHERE 
		      	 A.FacilityID = @facilityID  AND  
			A.DivisionID =@DivisionID AND 
			O.Errorcode ='0' AND
			O.Duration is Null AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate, @recordDate) <2;
		Else
			select isnull(RecordID,0) RecordID, (CASE Isnull(ToNo,'') When '' then 'Inactive' Else 'Active' End) Status,  	Isnull(PIN,0) as PIN, StationID, isnull(Tono,'') Tono , isnull(CAST(Recorddate AS Varchar(30)),'') ConnectDateTime ,
			 isnull(billtype,'') Billtype,	 Isnull(toCity,'') ToCity, isnull(ToState,'') toState
			From tblANIs A With(nolock) left outer join tblOncalls O with(nolock) on (A.ANIno =  O.fromNo and  A.facilityID =O.FacilityID)
			WHERE 
		      	 A.FacilityID = @facilityID  AND  
			O.Errorcode ='0' AND
			O.Duration is Null AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(hh,O.recorddate, @recordDate) <2;
	  end
 End
