CREATE PROCEDURE [dbo].[p_Report_Security_check1]
@facilityID	int ,  --Required
@inmateID	varchar(12),  -- Optional
@fromDate	smallDateTime,  --Required
@toDate	smallDatetime,   --Required
@RejectID int
 AS
If @inmateID <> '' and @RejectID <> 0
	select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  from tblcallsunbilled  t1  with(nolock) ,tblInmate t2  with(nolock), tblErrorType t3  with(nolock), tblANIs t4  with(nolock)
		where t1.fromno= t4.ANIno and
		 t1.facilityID=t4.facilityID  and 
		 t2.PIN =  t1.PIN and 
		 t1.facilityID = t2.facilityID and 
		 t1.errorType = t3.errortype and
		 t1.errorType in ('13', '14', '15') and 
		 RecordDate between @fromDate and @todate and  
		 t1.facilityID = @facilityID  and  
		 t2.InmateID =@inmateID and
		 t1.errorType = @RejectID
else
if(@inmateID ='')
    If @RejectID <> 0
    select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  from tblcallsunbilled  t1  with(nolock),tblInmate t2  with(nolock), tblErrorType t3  with(nolock), tblANIs t4  with(nolock)
	where t1.fromno= t4.ANIno and
		 t1.facilityID=t4.facilityID  and 
		 t2.PIN =  t1.PIN and 
		 t1.facilityID = t2.facilityID and 
		 t1.errorType = t3.errortype and
		 t1.errorType in ('13', '14', '15') and 
		 RecordDate between @fromDate and @todate  and  
		 t1.facilityID = @facilityID and
		 t1.errorType = @RejectID
	else
	select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  from tblcallsunbilled  t1  with(nolock),tblInmate t2  with(nolock), tblErrorType t3  with(nolock), tblANIs t4  with(nolock)
	where t1.fromno= t4.ANIno and
		 t1.facilityID=t4.facilityID  and 
		 t2.PIN =  t1.PIN and 
		 t1.facilityID = t2.facilityID and 
		 t1.errorType = t3.errortype and
		 t1.errorType in ('13', '14', '15') and  
		 RecordDate between @fromDate and @todate  and  t1.facilityID = @facilityID
else
	If @RejectID <> 0
		select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  from tblcallsunbilled  t1  with(nolock) ,tblInmate t2  with(nolock), tblErrorType t3  with(nolock), tblANIs t4  with(nolock)
		where t1.fromno= t4.ANIno and
		 t1.facilityID=t4.facilityID  and 
		 t2.PIN =  t1.PIN and 
		 t1.facilityID = t2.facilityID and 
		 t1.errorType = t3.errortype and
		 t1.errorType in ('13', '14', '15') and 
		 RecordDate between @fromDate and @todate and  
		 t1.facilityID = @facilityID  and  
		 t2.InmateID =@inmateID and
		 t1.errorType = @RejectID
	else
		select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  from tblcallsunbilled  t1  with(nolock) ,tblInmate t2  with(nolock), tblErrorType t3  with(nolock), tblANIs t4  with(nolock)
		where t1.fromno= t4.ANIno and
		 t1.facilityID=t4.facilityID  and 
		 t2.PIN =  t1.PIN and 
		 t1.facilityID = t2.facilityID and 
		 t1.errorType = t3.errortype and
		 t1.errorType in ('13', '14', '15') and 
		 RecordDate between @fromDate and @todate and  
		 t1.facilityID = @facilityID  and  
		 t2.InmateID =@inmateID
	
