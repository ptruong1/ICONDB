CREATE PROCEDURE [dbo].[p_Report_Security_check2]
@facilityID	int ,  --Required
@inmateID	varchar(12),  -- Optional
@fromDate	smallDateTime,  --Required
@toDate	smallDatetime,   --Required
@RejectID int
 AS
If @inmateID <> '' and @RejectID <> 0
begin
	select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  
	FROM [Leg_ICON].[dbo].[tblCallsUnbilled] t1
  inner join tblANIs t4 on t1.fromno= t4.ANIno 
  inner join tblInmate t2 on t2.PIN =  t1.PIN	 and status = 1
  inner join tblErrortype t3 on t3.errortype = t1.errortype
  where 		 
		RecordDate between @fromDate and @toDate and
		 t1.facilityID = @facilityId 
		 and t1.errorType = @RejectID
		 and t1.InmateID = @InmateID
end
else
if(@inmateID ='')
    If @RejectID <> 0
	begin
    select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  
	FROM [Leg_ICON].[dbo].[tblCallsUnbilled] t1
	  inner join tblANIs t4 on t1.fromno= t4.ANIno 
	  inner join tblInmate t2 on t2.PIN =  t1.PIN	 and status = 1
	  inner join tblErrortype t3 on t3.errortype = t1.errortype
	  where 		 
		RecordDate between @fromDate and @toDate and
		 t1.facilityID = @facilityId 
		 and t1.errorType = @RejectID
	end	 
	else
	begin
	select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  
	FROM [Leg_ICON].[dbo].[tblCallsUnbilled] t1
	  inner join tblANIs t4 on t1.fromno= t4.ANIno 
	  inner join tblInmate t2 on t2.PIN =  t1.PIN	 and status = 1
	  inner join tblErrortype t3 on t3.errortype = t1.errortype
	  where 		 
		RecordDate between @fromDate and @toDate and
		 t1.facilityID = @facilityId 
		 
    end
else
	If @RejectID <> 0
	begin
		select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  
	FROM [Leg_ICON].[dbo].[tblCallsUnbilled] t1
	  inner join tblANIs t4 on t1.fromno= t4.ANIno 
	  inner join tblInmate t2 on t2.PIN =  t1.PIN	 and status = 1
	  inner join tblErrortype t3 on t3.errortype = t1.errortype
	  where 		 
		RecordDate between @fromDate and @toDate and
		 t1.facilityID = @facilityId 
		 and t1.errorType = @RejectID
		 and t1.InmateID = @InmateID
	 end
	else
	begin
		select  StationID ,t1.PIN, t2.InmateID, t2.Firstname,t2.LastName,t3.descript,t1.RecordDate  
		FROM [Leg_ICON].[dbo].[tblCallsUnbilled] t1
		  inner join tblANIs t4 on t1.fromno= t4.ANIno 
		  inner join tblInmate t2 on t2.PIN =  t1.PIN	 and status = 1
		  inner join tblErrortype t3 on t3.errortype = t1.errortype
		  where 		 
		RecordDate between @fromDate and @toDate and
		 t1.facilityID = @facilityId 
		 and t1.errorType = @RejectID
		 and t1.InmateID = @InmateID
	end
