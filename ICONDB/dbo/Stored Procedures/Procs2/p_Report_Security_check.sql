CREATE PROCEDURE [dbo].[p_Report_Security_check]
@facilityID	int ,  --Required
@inmateID	varchar(12),  -- Optional
@fromDate	smallDateTime,  --Required
@toDate	smallDatetime   --Required
 AS

if(@inmateID ='')
	select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  from tblcallsunbilled  t1  with(nolock),tblInmate t2  with(nolock), tblErrorType t3  with(nolock), tblANIs t4  with(nolock)
	where t1.fromno= t4.ANIno and
		 t1.facilityID=t4.facilityID  and 
		 t2.PIN =  t1.PIN and 
		 t1.facilityID = t2.facilityID and 
		 t1.errorType = t3.errortype
		 and t1.errorType >12 and RecordDate between @fromDate and @todate  and  t1.facilityID = @facilityID
else
	select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  from tblcallsunbilled  t1  with(nolock) ,tblInmate t2  with(nolock), tblErrorType t3  with(nolock), tblANIs t4  with(nolock)
	where t1.fromno= t4.ANIno and
		 t1.facilityID=t4.facilityID  and 
		 t2.PIN =  t1.PIN and 
		 t1.facilityID = t2.facilityID and 
		 t1.errorType = t3.errortype
		 and t1.errorType >12 and RecordDate between @fromDate and @todate and  t1.facilityID = @facilityID  and  t2.InmateID =@inmateID
