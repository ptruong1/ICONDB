
CREATE PROCEDURE [dbo].[p_live_monitor_status_ShutDown]
@facilityID	int,
@DivisionID       int,
@locationID	int,
@ANINo	varchar(10)

AS
Declare   @timeZone  tinyint,  @recordDate datetime
select  @timeZone  = timezone from tblfacility with(nolock)  where facilityID = @facilityID 
Set  @recordDate = getdate()
set @recordDate = dateadd(hh, @timeZone, @recordDate) 

If(@ANINo <> '')
  begin
	
	Select O.FromNo, A.StationID, O.userName as IpAddress	From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
	WHERE A.ANIno =  O.fromNo  AND
	    	   A.facilityID =O.FacilityID AND
	      	 A.FacilityID = @facilityID AND  
		A.ANINo = @ANINo AND 
		O.Errorcode ='0' 
		--AND	O.Billtype < '12' 
		and O.duration is Null
			
  end
Else
 Begin
	If (@locationID	> 0 )
	 begin
		Select O.FromNo, A.StationID, O.userName as IpAddress From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
		WHERE A.ANIno =  O.fromNo  AND
	    	   A.facilityID =O.FacilityID AND
	      	 A.FacilityID = @facilityID  AND  
		A.LocationID =@locationID AND 
		O.Errorcode ='0' 
		--AND	O.Billtype < '12' 
		and O.duration is Null
		
	 end
	else
	   begin
		If (@DivisionID	> 0 )
		 begin
			Select O.FromNo, A.StationID, O.userName as IpAddress 	From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
			WHERE A.ANIno =  O.fromNo  AND
		    	   A.facilityID =O.FacilityID AND
		      	 A.FacilityID = @facilityID  AND  
			A.DivisionID =@DivisionID AND 
			O.Errorcode ='0' 
		--AND	O.Billtype < '12' 
		and O.duration is Null
			
		 end
		Else
		  begin
			Select O.FromNo, A.StationID, O.userName as IpAddress 	From tblANIs A With(nolock)  ,tblOncalls O with(nolock) 
			WHERE A.ANIno =  O.fromNo  AND
		    	   A.facilityID =O.FacilityID AND
		      	 A.FacilityID = @facilityID  AND  
			O.Errorcode ='0' 
		--AND	O.Billtype < '12' 
		and O.duration is Null
			
		 End
	  end
 End

