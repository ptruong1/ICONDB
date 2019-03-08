
CREATE PROCEDURE [dbo].[p_live_monitor_status]
@facilityID	int,
@DivisionID       int,
@locationID	int,
@stationID	varchar(30)
AS
Declare   @timeZone  tinyint,  @recordDate datetime
select  @timeZone  = timezone from tblfacility with(nolock)  where facilityID = @facilityID 
Set  @recordDate = getdate()
set @recordDate = dateadd(hh, @timeZone, @recordDate) 

If(@stationID <> '')
  begin
	
	if(select count(*) 	From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
	WHERE A.ANIno =  O.fromNo  AND
	    	   A.facilityID =O.FacilityID AND
	      	 A.FacilityID = @facilityID AND  
		A.StationID =@stationID AND 
		O.Errorcode ='0' AND
		O.Billtype < '12'  AND
		O.RecordFile <> 'NA' AND
		datediff(ss,O.LastModify, @recordDate) <20) > 0   return 1
  end
Else
 Begin
	If (@locationID	> 0 )
	 begin
		if(select count(*) 	From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
		WHERE A.ANIno =  O.fromNo  AND
	    	   A.facilityID =O.FacilityID AND
	      	 A.FacilityID = @facilityID  AND  
		A.LocationID =@locationID AND 
		O.Errorcode ='0' AND
		O.Billtype < '12'  AND
		O.RecordFile <> 'NA' AND
		datediff(ss,O.LastModify, @recordDate) <20 ) > 0   return 1
	 end
	else
	   begin
		If (@DivisionID	> 0 )
		 begin
			if(select count(*) 	From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
			WHERE A.ANIno =  O.fromNo  AND
		    	   A.facilityID =O.FacilityID AND
		      	 A.FacilityID = @facilityID  AND  
			A.DivisionID =@DivisionID AND 
			O.Errorcode ='0' AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(ss,O.LastModify, @recordDate) <15 ) > 0   return 1
		 end
		Else
		  begin
			if(select count(*) 	From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
			WHERE A.ANIno =  O.fromNo  AND
		    	   A.facilityID =O.FacilityID AND
		      	 A.FacilityID = @facilityID  AND  
			O.Errorcode ='0' AND
			O.Billtype < '12'  AND
			O.RecordFile <> 'NA' AND
			datediff(ss,O.LastModify, @recordDate) <15 ) > 0   return 1
		 End
	  end
 End

