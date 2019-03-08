

CREATE FUNCTION [dbo].[fn_checkFormLimit] (@facilityID int, @InmateID varchar(12),  @formTypeID tinyint)
RETURNS tinyint  AS  
BEGIN 
	Declare  @FormPerDay tinyint, @FormPerWeek tinyint, @FormPerMonth tinyint;
	SET @FormPerDay  =0;
	SET @FormPerWeek  =0; 
	SET @FormPerMonth =0; -- select * from  tblInmateRequestForm
	select @FormPerDay=isnull( PerDay,0), @FormPerWeek= isnull(PerWeek,0), @FormPerMonth =isnull(PerMonth,0) from tblFormInmateConfig where facilityID = @facilityID and formtype = @formtypeID and InmateID = @inmateID;
	
	if(@FormPerDay =0 and @FormPerWeek =0 and  @FormPerMonth=0)
		select @FormPerDay=isnull( PerDay,0), @FormPerWeek= isnull(PerWeek,0), @FormPerMonth = isnull(PerMonth,0) from tblFormFacilityConfig with(nolock)  where facilityID =@facilityID and formtypeID = @formtypeID;
	if(@FormPerDay =0 and @FormPerWeek =0 and  @FormPerMonth=0)
		return 1;
	Else
	  begin
		if(@formtypeID =1) 
		 begin
			if(select count(*) from tblInmateRequestForm with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day, Requestdate, getdate())=0) <@FormPerDay
				if(select count(*) from tblInmaterequestform with(nolock)  where facilityID = @facilityID and InmateID = @InmateID and  datediff(day, Requestdate, getdate())<7) <@FormPerWeek
						if(select count(*) from tblInmaterequestform  with(nolock) where facilityID = @facilityID and InmateID = @InmateID and  datediff(day, Requestdate, getdate())<30 ) <@FormPerMonth
							return 1;
		 end
		else if(@formtypeID =2) 
		begin
			if(select count(*) from tblMedicalKiteForm with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day, Requestdate, getdate())=0) <@FormPerDay
				if(select count(*) from tblMedicalKiteForm with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day, Requestdate, getdate())<7) <@FormPerWeek
					if(select count(*) from tblMedicalKiteForm with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day, Requestdate, getdate())<30) <@FormPerMonth
						return 1;
		 end
		else if(@formtypeID =3) 
		begin
			if(select count(*) from tblgrievanceform with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day, grievanceReporttime, getdate())=0) <@FormPerDay
				if(select count(*) from tblgrievanceform with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day, grievanceReporttime, getdate())<7) <@FormPerWeek
						if(select count(*) from tblgrievanceform with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day, grievanceReporttime, getdate())<30) <@FormPerMonth
							return 1;
		 end
		else if(@formtypeID =4) 
		begin
			if(select count(*) from tblInmateLegalRequest with(nolock)  where facilityID = @facilityID and InmateID = @InmateID and datediff(day,  RecordDate, getdate())=0) <@FormPerDay
					if(select count(*) from tblInmateLegalRequest with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day,  RecordDate, getdate())<7) <@FormPerWeek
						if(select count(*) from tblInmateLegalRequest with(nolock) where facilityID = @facilityID and InmateID = @InmateID and datediff(day,  RecordDate, getdate())<30) <@FormPerMonth
							return 1;
		 end
	  end

	 return 0;
End



